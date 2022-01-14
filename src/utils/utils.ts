import fs from 'fs-extra';
import util from 'util';
import child_process from 'child_process';
export const copy = fs.copy;
export const copyFile = util.promisify(fs.copyFile);
export const exec = util.promisify(child_process.exec);
export const exists = util.promisify(fs.pathExists);
export const lstat = util.promisify(fs.lstat);
export const mkdir = util.promisify(fs.mkdir);
export const readDir = util.promisify(fs.readdir);
export const readFile = util.promisify(fs.readFile);
export const readlink = util.promisify(fs.readlink);
export const remove = util.promisify(fs.remove);
export const unlink = util.promisify(fs.unlink);
export const writeFile = util.promisify(fs.writeFile);

/**
 * Adds a delay, mostly used for testing
 *
 * Usage: `await delay(1000)`
 */
export async function delay(ms: number): Promise<void> {
	await new Promise((resolve) => setTimeout(resolve, ms));
}

/**
 * Returns true if `needle` exists in `fileName`
 */
export async function searchFile(fileName: string, needle: string): Promise<boolean> {
	try {
		await exec(`grep -qF ${needle} ${fileName}`);
	} catch (err) {
		return false;
	}

	return true;
}

/**
 * Console logs `message` if `verbose` is set to `true`
 */
export function log(
	message: string | object | Array<any>,
	verbose: boolean = true
) {
	if (verbose) console.log(message);
}
