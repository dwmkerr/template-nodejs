default: help

# See: https://github.com/dwmkerr/makefile-help for how 'help' works.
.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

.PHONY: build
build: # Build the code - for Node.js this means just install packages.
	npm install

.PHONY: test
test: build # Test the code. First lints, then runs the unit tests, checking coverage.
	npm run lint
	npm run test

.PHONY: rename-template
rename-template: # Set your own GitHub username and project name.
	./scripts/rename-module.sh
