const debug = require('debug')('template-nodejs-module');
const helloWorld = require('./lib/hello-world');
const package = require('./package.json');

debug(`Package name: ${package.name}`);
debug(`Package version: ${package.version}`);

debug('Preparing to greet...');
const greeting = helloWorld();
console.log(greeting);
