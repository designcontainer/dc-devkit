import { checkWpCliInstalled, checkMySQLConnection, checkSSHAccess, checkGitAccess, checkEmptyGitRepo, databaseExists } from '../utils/checks';
import path from 'path';
import axios from 'axios';
import unzip from 'extract-zip';
import simpleGit, { SimpleGit } from 'simple-git';
import { writeFile, copy, exists, unlink, remove, exec, readFile, searchFile, log } from '../utils/utils';
import { NodeSSH } from 'node-ssh';
import os from 'os';

const git: SimpleGit = simpleGit();
const homedir = os.homedir();

/**
 * Downloads a new core zip file from Wordpress.org.
 *
 * @return {string} Returns a string with the zip file path.
 */
async function downloadNewWpCore(wordpressPath: string): Promise<string> {
	const url = 'https://wordpress.org/latest.zip';
	const file = path.join(wordpressPath, 'core.zip');
	log('Downloading new WP core');
	return await axios
		.request({
			url,
			method: 'GET',
			responseType: 'arraybuffer',
		})
		.then(async (result) => {
			// await writeFile(file, result.data);
			return file;
		})
		.catch((err) => {
			throw new Error(err);
		});
};

/**
 * Check if the install contains the necessary Wordpress core files.
 *
 * @param {String} wordpressPath
 * @return {bool} Returns true/false on whether the core files exist.
 */
async function isWpCoreInstalled(wordpressPath: string): Promise<boolean> {
	log('Checking if WP core is installed');
	const FOLDERS_TO_TEST = ['wp-admin', 'wp-includes'];
	for (let folder of FOLDERS_TO_TEST) {
		const folderExists = await exists(path.join(wordpressPath, folder));
		if (!folderExists) {
			return false;
		}
	}
	return true;
};

/**
 * Handles the install and setup of the wordpress core.
 *
 * TODO: Should this return bool?
 */
async function installNewWpCore(installPath: string): Promise<boolean> {
	if (await isWpCoreInstalled(installPath)) {
		return false;
	}

	// TODO: Code does not work from here on.
	log('Installing new WP core');
	const coreZip = await downloadNewWpCore(installPath);
	await unzip(coreZip, {
		dir: installPath,
	});
	await unlink(coreZip);
	const coreFolder = path.join(installPath, 'wordpress');

	// Delete the wp-content folder.
	await remove(path.join(coreFolder, 'wp-content'));

	// Copy contents of coreFolder to wordpressPath
	await copy(coreFolder, installPath);

	// Delete the coreFolder
	await remove(coreFolder);
	return true;
};

/**
 * Gets the SQL file from the host server and copies it to the wpe-dist folder inside the working path.
 *
 * @param {NodeSSH} conn The SSH connection
 * @param {string} installName Name of the install.
 * @returns {void}
 */
async function getDatabaseDump(conn: NodeSSH, installName: string): Promise<void> {
	const installPath = path.join('.', installName);

	// Export db on live server
	log('Exporting db dump');
	await conn.exec(`wp db export sites/${installName}/dump.sql >/dev/null 2>&1`, []);

	// Get the db dump and put it in our install folder
	log('Getting dump');
	await exec(`rsync -e "ssh" ${installName}@${installName}.ssh.wpengine.net:/sites/${installName}/dump.sql ${installPath}/dump.sql`);

	// Delete the db dump from lvie server
	log('Deleting dump from server');
	await conn.exec(`rm -rf sites/${installName}/dump.sql`, []);

	return;
};

/**
 * Manages the database setup
 *
 * @param {string} installName The install name.
 * @return {void}
 */
async function setupDatabase(installName: string): Promise<void> {
	const ssh: NodeSSH = new NodeSSH();
	const SQLUser = 'root';
	const SQLPass = 'root';

	const privateKey: string =
	await readFile(path.join(homedir, '/.ssh/id_rsa')).then((res: any) => {
		return res.toString();
	});

	log('Connecting to server');
	const conn: NodeSSH = await ssh.connect({
		privateKey,
		host: `${installName}.ssh.wpengine.net`,
		username: installName,
	});

	// Export and get the DB dump from live server
	await getDatabaseDump(conn, installName);

	const MySQLPath = '/Applications/MAMP/Library/bin/mysql';

	// Create a new database
	log('Creating database');
	await exec(`${MySQLPath} -u${SQLUser} -p${SQLPass} -e "CREATE DATABASE ${installName}"`);

	// Import database
	log('Importing database');
	await exec(`${MySQLPath} -u${SQLUser} -p${SQLPass} -f -D ${installName} < ./${installName}/dump.sql`);

	// Delete database dump from install directory
	log('Deleting database dump from install directory');
	await exec(`rm ${path.join('./', installName, 'dump.sql')}`);

	return;

	// TODO: Do the things below from OG devkit
	//     # Delete Search WP tables if they exist, because they are causing conflicts on import
	//     drop_swp_statement=$($mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "
	// SELECT CONCAT( 'DROP TABLE ', GROUP_CONCAT(table_name) , ';' )
	//     AS statement FROM information_schema.tables
	//     WHERE table_schema = '$sitename' AND table_name LIKE '%_swp_%'" 2>/dev/null)
	//     $mysql_path -N -u$sqluser -p$sqlpass -D $sitename -h localhost -e "$drop_swp_statement" 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."
}

async function configureVHosts(installName: string): Promise<void> {
	const vHostsFile = `/Applications/MAMP/conf/apache/extra/httpd-vhosts.conf`;

	// Check if install exists in hosts file
	log(`Checking if vhosts entry for ${installName} exists`);
	if (!await searchFile(vHostsFile, `ServerName ${installName}.test`)) {
		log(`Adding ${installName} entry to vhosts file`);
		// TODO: Append install to vhosts file
		return;
	}

	return;
}

/**
 * The action function for the clone command.
 */
async function clone(installName: string): Promise<void> {
	/**
	 * Misc checks
	 */
	try {
		if (!checkWpCliInstalled())            throw new Error('WordPress CLI is not installed');
		if (!checkMySQLConnection())           throw new Error('WordPress CLI is not installed');
		if (!checkSSHAccess())                 throw new Error('Does not have SSH access');
		if (!checkGitAccess())                 throw new Error('Does not have Git access');
		if (!checkEmptyGitRepo())              throw new Error('Git repo is empty');
		if (await databaseExists(installName)) throw new Error('Database already exists');
	} catch(err) {
		console.error(err);
		return;
	}

	// Clone the repo
	log('Cloning repo');
	await git.clone(
		`https://github.com/designcontainer/${installName}`, `./${installName}`
	).catch((err: any) => {
		throw new Error(err);
	});

	// Install WP core (Will only install new one if there isn't a WP core in the repo)
	await installNewWpCore(`./${installName}`);

	// Export the database from live server and copy it to the install folder
	await setupDatabase(installName);

	await configureVHosts(installName);

	log('Site is set up!');

	// Quit
	process.exit(0);
}

export default clone;
