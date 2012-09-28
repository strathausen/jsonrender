/*

Stream api wrapper for the handlebars mustache implementation

@author Johann Philipp Strathausen <strathausen@gmail.com>
*/
var Schnauzer, hbs, mapStream,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

mapStream = require('map-stream');

hbs = require('handlebars');

Schnauzer = (function() {

  function Schnauzer() {
    this.stream = __bind(this.stream, this);
    this.compile = __bind(this.compile, this);
  }

  Schnauzer.prototype.compile = function(template, layout) {
    var tpl;
    tpl = layout || template;
    if (layout != null) hbs.registerPartial('body', template);
    return hbs.compile(tpl);
  };

  Schnauzer.prototype.stream = function(template, layout) {
    var _this = this;
    return mapStream(function(content, cb) {
      return cb(null, (_this.compile(template, layout))(JSON.parse(content)));
    });
  };

  return Schnauzer;

})();

module.exports = new Schnauzer;
