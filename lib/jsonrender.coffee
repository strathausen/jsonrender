###

Stream api wrapper for the handlebars mustache implementation

@author Johann Philipp Strathausen <strathausen@gmail.com>

###

mapStream = require 'map-stream'
hbs       = require 'handlebars'
fs        = require 'fs'
async     = require 'async'

class JsonRender
  # Template cache
  templates: {}

  # @argument template - The actual body template, not the file name
  # @argument layout - The actual layout template, not the file name
  compile: (template, layout) =>
    tpl = layout or template
    if layout
      hbs.registerPartial 'body', template
    hbs.compile tpl

  # @argument fTemplate - The body template file name
  # @argument fLayout - The layout template file name
  stream: (fTemplate, fLayout) => mapStream (content, cb) =>
    fTemplate or= content.template
    fLayout or= content.layout
    if typeof content is 'string' or content instanceof Buffer
      content = JSON.parse content
    async.parallel
      template: (cb) =>
        if @templates[fTemplate]?
          return cb null, @templates[fTemplate]
        fs.readFile fTemplate, 'utf8', (err, template) =>
          return cb err if err
          @templates[fTemplate] = template
          cb null, template

      layout: (cb) =>
        return do cb unless fLayout
        if @templates[fLayout]?
          return cb null, @templates[fLayout]
        fs.readFile fLayout, 'utf8', (err, layout) =>
          return cb err if err
          @templates[fLayout] = layout
          cb null, layout

    , (err, { template, layout }) =>
      cb null, (@compile template, layout) content

module.exports = new JsonRender
