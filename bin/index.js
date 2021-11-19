"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var commander_1 = require("commander");
var version_1 = __importDefault(require("./commands/version"));
var update_1 = __importDefault(require("./commands/update"));
var clone_1 = __importDefault(require("./commands/clone"));
var db_1 = __importDefault(require("./commands/db"));
var remove_1 = __importDefault(require("./commands/remove"));
var program = new commander_1.Command();
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
    .action(version_1.default);
program.command('update')
    .description('update devkit')
    .action(update_1.default);
program.command('clone <install>')
    .description('clone devkit')
    // .option('-i, --install <install>', 'undefined')
    .action(clone_1.default);
program.command('db')
    .description('get or dump database')
    .action(db_1.default);
program.command('remove')
    .description('remove install')
    .action(remove_1.default);
/**
 * Inititate the program
 */
program.parse(process.argv);
