import {Command} from 'commander';
import start from './commands/start';
import clone from './commands/clone';

const program = new Command()

program.command('start')
  .description('start the cli tool')
  .action(start)

program.command('clone')
	.description('clone the cli tool')
	.action(clone)
