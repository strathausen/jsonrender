.PHONY: test

compile:
	coffee -j index.js -bc lib/jsonrender.coffee
	coffee -j bin/jsonrender.js -bc lib/jsonrender_cmd.coffee
	chmod +x bin/*.js
	echo '0a\n#!/usr/bin/env node\n.\nw' | ed bin/*.js
test: compile
	@node_modules/.bin/mocha test/test.coffee
