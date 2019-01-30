# README (Style guide guide)

## Getting up and running
* bundle
* yarn install

Terminal 1:
* rails s

Terminal 2:
* webpack-dev-server

## Runnning Tests
Terminal 3:
* yarn test

This will run all tests in `**.spec.js` files contained within the `components` file.
The tests run using Jest and will re-run within the terminal on saved changes. Console logs are printed into the terminal.

If you are using imports from node_modules, make sure to add the modules (as exceptions) to transformIgnorePatterns in package.json, to make sure these are transpiled.

Also, if verbose is set to true for yarn test, often console logs are overwritten in the terminal when using --watchAll. Another solution to the missing logs is to do a single test run (remove --watchAll)