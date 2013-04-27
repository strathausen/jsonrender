# Jsonrender

`jsonrender` is a

- Stream wrapper around the mustache handlebars implementation
- Command line tool for rendering handlebars templates
- A very small node module that wraps around handlebars to offer an `express`-like mechanism for embedding a `body` temlpate inside a `layout` template

## Usage

### As a module

``` js
var jsonrender = require('jsonrender');
var template = '<foo>{{bar}}</foo>';
var layout = '<baz>{{>body}}</baz>';
var render = jsonrender.compile(template);
var renderWithLayout = jsonrender.compile(template, layout);

console.log(render({ bar: 'buh' }));
// '<foo>buh</foo>'

console.log(renderWithLayout({ bar: 'buh' });
// '<baz><foo>buh</foo></baz>'
```

### As a command line utility

``` bash
$ cat template.hbs
<h1>{{title}}</h1>

$ cat layout.hbs
<head></head><body>{{>body}}</body>

$ echo '{title: "The Title"}' | jsonrender --template template.hbs
<h1>The Title</h1>

$ echo '{title: "The Title"}' | jsonrender --template template.hbs \
  --layout layout.hbs
<head></head><body><h1>The Title</h1></body> 
```

