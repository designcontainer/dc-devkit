import { Command } from 'commander';
var program = new Command();

program.command('start')
	.arguments('<name>')
	.description('start the server')
	.action(start);
