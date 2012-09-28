#!/usr/bin/env node
/*

@author
*/
var body, fs, layout, path, program, rendererStream, schnauzer, sourceStream;

program = require('commander');

schnauzer = require('./schnauzer');

path = require('path');

fs = require('fs');

program.description('Render json in mustache templates. If the optional\
  "layout" template is present, it will wrap around the file\
  given in the option "body" whereas "body" will be present\
  as a partial named "body" in the "layout" template.').version('0.0.1').option('-b, --body <filename>', 'handlebars mustache template').option('-l, --layout <filename>', 'handlebars mustache template (layout, frame)').option('-f, --file <filename>', 'json document').parse(process.argv);

if (program.file) {
  sourceStream = fs.createReadStream(program.file);
} else {
  process.stdin.resume();
  sourceStream = process.stdin;
}

body = fs.readFileSync(program.body, 'utf8');

if (program.layout != null) {
  layout = fs.readFileSync(program.layout, 'utf8');
  rendererStream = schnauzer.stream(body, layout);
} else {
  rendererStream = schnauzer.stream(body);
}

sourceStream.pipe(rendererStream).pipe(process.stdout);