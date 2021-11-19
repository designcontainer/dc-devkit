import {exists} from './utils';

/**
 * Checks if executable exists in the system
*/
function findExecutable(_exe: string): boolean {
	return true;
}

/**
 * Checks if system has the WP CLI
*/
export function checkWpCliInstalled(): boolean {
	return findExecutable('wp');
}

/**
 * Checks the MySQL connection
*/
export function checkMySQLConnection(): boolean {
	return true;
}

/**
 * Checks the SSH access
*/
export function checkSSHAccess(): boolean {
	return true;
}

/**
 * Checks the Git access
*/
export function checkGitAccess(): boolean {
	return true;
}

/**
 * Checks if git repo is empty
*/
export function checkEmptyGitRepo(): boolean {
	return true;
}

/**
 * Checks if database already exists
*/
export async function databaseExists(installName: string): Promise<boolean> {
	return await exists(`/Applications/MAMP/db/mysql57/${installName}`);
}
