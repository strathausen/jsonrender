/*

Stream api wrapper for the handlebars mustache implementation

@author Johann Philipp Strathausen <strathausen@gmail.com>
*/
var Schnauzer, async, fs, hbs, mapStream,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

mapStream = require('map-stream');

hbs = require('handlebars');

fs = require('fs');

async = require('async');

Schnauzer = (function() {

  function Schnauzer() {
    this.stream = __bind(this.stream, this);
    this.compile = __bind(this.compile, this);
  }

  Schnauzer.prototype.templates = {};

  Schnauzer.prototype.compile = function(template, layout) {
    var tpl;
    tpl = layout || template;
    if (layout) hbs.registerPartial('body', template);
    return hbs.compile(tpl);
  };

  Schnauzer.prototype.stream = function(fTemplate, fLayout) {
    var _this = this;
    return mapStream(function(content, cb) {
      fTemplate || (fTemplate = content.template);
      fLayout || (fLayout = content.layout);
      if (typeof content === 'string' || content instanceof Buffer) {
        content = JSON.parse(content);
      }
      return async.parallel({
        template: function(cb) {
          if (_this.templates[fTemplate] != null) {
            return cb(null, _this.templates[fTemplate]);
          }
          return fs.readFile(fTemplate, 'utf8', function(err, template) {
            if (err) return cb(err);
            _this.templates[fTemplate] = template;
            return cb(null, template);
          });
        },
        layout: function(cb) {
          if (!fLayout) return cb();
          if (_this.templates[fLayout] != null) {
            return cb(null, _this.templates[fLayout]);
          }
          return fs.readFile(fLayout, 'utf8', function(err, layout) {
            if (err) return cb(err);
            _this.templates[fLayout] = layout;
            return cb(null, layout);
          });
        }
      }, function(err, _arg) {
        var layout, template;
        template = _arg.template, layout = _arg.layout;
        return cb(null, (_this.compile(template, layout))(content));
      });
    });
  };

  return Schnauzer;

})();

module.exports = new Schnauzer;
