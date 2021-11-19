import {Command} from 'commander';
import version from './commands/version';
import update from './commands/update';
import clone from './commands/clone';
import db from './commands/db';
import remove from './commands/remove';

const program = new Command()

/**
 * Program info and global options
 */
program
	.version('0.0.1')
	.option('-h, --help', 'show help menu');

/**
 * Program commands
 */
program.command('version')
	.description('show version of devkit')
	.action(version)

program.command('update')
	.description('update devkit')
	.action(update)

program.command('clone <install>')
	.description('clone devkit')
	// .option('-i, --install <install>', 'undefined')
	.action(clone)

program.command('db')
	.description('get or dump database')
	.action(db)

program.command('remove')
	.description('remove install')
	.action(remove)

/**
 * Inititate the program
 */
program.parse(process.argv);
