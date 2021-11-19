"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var checks_1 = require("../utils/checks");
var path_1 = __importDefault(require("path"));
var axios_1 = __importDefault(require("axios"));
var extract_zip_1 = __importDefault(require("extract-zip"));
var simple_git_1 = __importDefault(require("simple-git"));
var utils_1 = require("../utils/utils");
var node_ssh_1 = require("node-ssh");
var os_1 = __importDefault(require("os"));
var git = (0, simple_git_1.default)();
var homedir = os_1.default.homedir();
/**
 * Downloads a new core zip file from Wordpress.org.
 *
 * @return {string} Returns a string with the zip file path.
 */
function downloadNewWpCore(wordpressPath) {
    return __awaiter(this, void 0, void 0, function () {
        var url, file;
        var _this = this;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    url = 'https://wordpress.org/latest.zip';
                    file = path_1.default.join(wordpressPath, 'core.zip');
                    (0, utils_1.log)('Downloading new WP core');
                    return [4 /*yield*/, axios_1.default
                            .request({
                            url: url,
                            method: 'GET',
                            responseType: 'arraybuffer',
                        })
                            .then(function (result) { return __awaiter(_this, void 0, void 0, function () {
                            return __generator(this, function (_a) {
                                // await writeFile(file, result.data);
                                return [2 /*return*/, file];
                            });
                        }); })
                            .catch(function (err) {
                            throw new Error(err);
                        })];
                case 1: return [2 /*return*/, _a.sent()];
            }
        });
    });
}
;
/**
 * Check if the install contains the necessary Wordpress core files.
 *
 * @param {String} wordpressPath
 * @return {bool} Returns true/false on whether the core files exist.
 */
function isWpCoreInstalled(wordpressPath) {
    return __awaiter(this, void 0, void 0, function () {
        var FOLDERS_TO_TEST, _i, FOLDERS_TO_TEST_1, folder, folderExists;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    (0, utils_1.log)('Checking if WP core is installed');
                    FOLDERS_TO_TEST = ['wp-admin', 'wp-includes'];
                    _i = 0, FOLDERS_TO_TEST_1 = FOLDERS_TO_TEST;
                    _a.label = 1;
                case 1:
                    if (!(_i < FOLDERS_TO_TEST_1.length)) return [3 /*break*/, 4];
                    folder = FOLDERS_TO_TEST_1[_i];
                    return [4 /*yield*/, (0, utils_1.exists)(path_1.default.join(wordpressPath, folder))];
                case 2:
                    folderExists = _a.sent();
                    if (!folderExists) {
                        return [2 /*return*/, false];
                    }
                    _a.label = 3;
                case 3:
                    _i++;
                    return [3 /*break*/, 1];
                case 4: return [2 /*return*/, true];
            }
        });
    });
}
;
/**
 * Handles the install and setup of the wordpress core.
 *
 * TODO: Should this return bool?
 */
function installNewWpCore(installPath) {
    return __awaiter(this, void 0, void 0, function () {
        var coreZip, coreFolder;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, isWpCoreInstalled(installPath)];
                case 1:
                    if (_a.sent()) {
                        return [2 /*return*/, false];
                    }
                    // TODO: Code does not work from here on.
                    (0, utils_1.log)('Installing new WP core');
                    return [4 /*yield*/, downloadNewWpCore(installPath)];
                case 2:
                    coreZip = _a.sent();
                    return [4 /*yield*/, (0, extract_zip_1.default)(coreZip, {
                            dir: installPath,
                        })];
                case 3:
                    _a.sent();
                    return [4 /*yield*/, (0, utils_1.unlink)(coreZip)];
                case 4:
                    _a.sent();
                    coreFolder = path_1.default.join(installPath, 'wordpress');
                    // Delete the wp-content folder.
                    return [4 /*yield*/, (0, utils_1.remove)(path_1.default.join(coreFolder, 'wp-content'))];
                case 5:
                    // Delete the wp-content folder.
                    _a.sent();
                    // Copy contents of coreFolder to wordpressPath
                    return [4 /*yield*/, (0, utils_1.copy)(coreFolder, installPath)];
                case 6:
                    // Copy contents of coreFolder to wordpressPath
                    _a.sent();
                    // Delete the coreFolder
                    return [4 /*yield*/, (0, utils_1.remove)(coreFolder)];
                case 7:
                    // Delete the coreFolder
                    _a.sent();
                    return [2 /*return*/, true];
            }
        });
    });
}
;
/**
 * Gets the SQL file from the host server and copies it to the wpe-dist folder inside the working path.
 *
 * @param {NodeSSH} conn The SSH connection
 * @param {string} installName Name of the install.
 * @returns {void}
 */
function getDatabaseDump(conn, installName) {
    return __awaiter(this, void 0, void 0, function () {
        var installPath;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    installPath = path_1.default.join('.', installName);
                    // Export db on live server
                    (0, utils_1.log)('Exporting db dump');
                    return [4 /*yield*/, conn.exec("wp db export sites/" + installName + "/dump.sql >/dev/null 2>&1", [])];
                case 1:
                    _a.sent();
                    // Get the db dump and put it in our install folder
                    (0, utils_1.log)('Getting dump');
                    return [4 /*yield*/, (0, utils_1.exec)("rsync -e \"ssh\" " + installName + "@" + installName + ".ssh.wpengine.net:/sites/" + installName + "/dump.sql " + installPath + "/dump.sql")];
                case 2:
                    _a.sent();
                    // Delete the db dump from lvie server
                    (0, utils_1.log)('Deleting dump from server');
                    return [4 /*yield*/, conn.exec("rm -rf sites/" + installName + "/dump.sql", [])];
                case 3:
                    _a.sent();
                    return [2 /*return*/];
            }
        });
    });
}
;
/**
 * Manages the database setup
 *
 * @param {string} installName The install name.
 * @return {void}
 */
function setupDatabase(installName) {
    return __awaiter(this, void 0, void 0, function () {
        var ssh, SQLUser, SQLPass, privateKey, conn, MySQLPath;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    ssh = new node_ssh_1.NodeSSH();
                    SQLUser = 'root';
                    SQLPass = 'root';
                    return [4 /*yield*/, (0, utils_1.readFile)(path_1.default.join(homedir, '/.ssh/id_rsa')).then(function (res) {
                            return res.toString();
                        })];
                case 1:
                    privateKey = _a.sent();
                    (0, utils_1.log)('Connecting to server');
                    return [4 /*yield*/, ssh.connect({
                            privateKey: privateKey,
                            host: installName + ".ssh.wpengine.net",
                            username: installName,
                        })];
                case 2:
                    conn = _a.sent();
                    // Export and get the DB dump from live server
                    return [4 /*yield*/, getDatabaseDump(conn, installName)];
                case 3:
                    // Export and get the DB dump from live server
                    _a.sent();
                    MySQLPath = '/Applications/MAMP/Library/bin/mysql';
                    // Create a new database
                    (0, utils_1.log)('Creating database');
                    return [4 /*yield*/, (0, utils_1.exec)(MySQLPath + " -u" + SQLUser + " -p" + SQLPass + " -e \"CREATE DATABASE " + installName + "\"" /* 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."` */)];
                case 4:
                    _a.sent();
                    // Import database
                    (0, utils_1.log)('Importing database');
                    return [4 /*yield*/, (0, utils_1.exec)(MySQLPath + " -u" + SQLUser + " -p" + SQLPass + " -f -D " + installName + " < ./" + installName + "/dump.sql" /* 2>/dev/null | grep -v "mysql: [Warning] Using a password on the command line interface can be insecure."` */)];
                case 5:
                    _a.sent();
                    // Delete database dump from install directory
                    (0, utils_1.log)('Deleting database dump from install directory');
                    return [4 /*yield*/, (0, utils_1.exec)("rm " + path_1.default.join('./', installName, 'dump.sql'))];
                case 6:
                    _a.sent();
                    return [2 /*return*/];
            }
        });
    });
}
function configureVHosts(installName) {
    return __awaiter(this, void 0, void 0, function () {
        var vHostsFile;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    (0, utils_1.log)({ installName: installName });
                    vHostsFile = "/Applications/MAMP/conf/apache/extra/httpd-vhosts.conf";
                    // Check if install exists in hosts file
                    (0, utils_1.log)("Checking if vhosts entry for " + installName + " exists");
                    return [4 /*yield*/, (0, utils_1.searchFile)(vHostsFile, "ServerName " + installName + ".test")];
                case 1:
                    if (!(_a.sent())) {
                        // TODO: Append install to vhosts file
                        return [2 /*return*/];
                    }
                    return [2 /*return*/];
            }
        });
    });
}
/**
 * The action function for the clone command.
 */
function clone(installName) {
    return __awaiter(this, void 0, void 0, function () {
        var err_1;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    _a.trys.push([0, 2, , 3]);
                    if (!(0, checks_1.checkWpCliInstalled)())
                        throw new Error('WordPress CLI is not installed');
                    if (!(0, checks_1.checkMySQLConnection)())
                        throw new Error('WordPress CLI is not installed');
                    if (!(0, checks_1.checkSSHAccess)())
                        throw new Error('Does not have SSH access');
                    if (!(0, checks_1.checkGitAccess)())
                        throw new Error('Does not have Git access');
                    if (!(0, checks_1.checkEmptyGitRepo)())
                        throw new Error('Git repo is empty');
                    return [4 /*yield*/, (0, checks_1.databaseExists)(installName)];
                case 1:
                    if (_a.sent())
                        throw new Error('Database already exists');
                    return [3 /*break*/, 3];
                case 2:
                    err_1 = _a.sent();
                    console.error(err_1);
                    return [2 /*return*/];
                case 3:
                    // Clone the repo
                    (0, utils_1.log)('Cloning repo');
                    return [4 /*yield*/, git.clone("https://github.com/designcontainer/" + installName, "./" + installName).catch(function (err) {
                            throw new Error(err);
                        })];
                case 4:
                    _a.sent();
                    // Install WP core (Will only install new one if there isn't a WP core in the repo)
                    return [4 /*yield*/, installNewWpCore("./" + installName)];
                case 5:
                    // Install WP core (Will only install new one if there isn't a WP core in the repo)
                    _a.sent();
                    // Export the database from live server and copy it to the install folder
                    return [4 /*yield*/, setupDatabase(installName)];
                case 6:
                    // Export the database from live server and copy it to the install folder
                    _a.sent();
                    return [4 /*yield*/, configureVHosts(installName)];
                case 7:
                    _a.sent();
                    (0, utils_1.log)('Site is set up!');
                    // Quit
                    process.exit(0);
                    return [2 /*return*/];
            }
        });
    });
}
exports.default = clone;
