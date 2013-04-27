jsonrender = require '../lib/jsonrender'
assert    = require 'assert'
{ exec }  = require 'child_process'
mapStream = require 'map-stream'

describe 'jsonrender - mustache/handlebars', ->
  describe '#compile', ->
    it 'with partial', ->
      renderer = jsonrender.compile '<bar>{{title}}</bar>', '<foo>{{>body}}</foo>'
      result = renderer title: 'Titlul'
      assert.equal result, '<foo><bar>Titlul</bar></foo>'

    it 'without partial', ->
      renderer = jsonrender.compile '<bar>{{title}}</bar>'
      result = renderer title: 'Titlul'
      assert.equal result, '<bar>Titlul</bar>'

  describe '#stream', ->
    describe 'templates as object properties', ->
      it 'with partial', (done) ->
        doc =
          title: 'Titlul'
          template: "#{__dirname}/template.mustache"
          layout: "#{__dirname}/layout.mustache"
        stream = jsonrender.stream()
        (stream).pipe mapStream (html) ->
          assert.equal html, '<foo><bar>Titlul</bar>\n</foo>\n'
          do done
        stream.write doc

      it 'without partial', (done) ->
        doc =
          title: 'Titlul'
          template: "#{__dirname}/template.mustache"
        stream = jsonrender.stream()
        (stream).pipe mapStream (html) ->
          assert.equal html, '<bar>Titlul</bar>\n'
          do done
        stream.write doc
        
    describe 'templates as arguments', ->
      it 'with partial', (done) ->
        doc =
          title: 'Titlul'
        template = "#{__dirname}/template.mustache"
        layout = "#{__dirname}/layout.mustache"
        stream = jsonrender.stream template, layout
        (stream).pipe mapStream (html) ->
          assert.equal html, '<foo><bar>Titlul</bar>\n</foo>\n'
          do done
        stream.write doc

      it 'without partial', (done) ->
        doc =
          title: 'Titlul'
        template = "#{__dirname}/template.mustache"
        stream = jsonrender.stream template
        (stream).pipe mapStream (html) ->
          assert.equal html, '<bar>Titlul</bar>\n'
          do done
        stream.write doc

    describe 'content as string', ->
      it 'without partial', (done) ->
        doc =
          title: 'Titlul'
        template = "#{__dirname}/template.mustache"
        stream = jsonrender.stream template
        (stream).pipe mapStream (html) ->
          assert.equal html, '<bar>Titlul</bar>\n'
          do done
        stream.write JSON.stringify doc

  describe 'cli', ->
    it 'with partial', (done) ->
      cmd =
        "echo \"{\\\"title\\\":\\\"Titlul\\\"}\" |
          coffee #{__dirname}/../lib/jsonrender_cmd.coffee
          --body #{__dirname}/template.mustache
          --layout #{__dirname}/layout.mustache"
      exec cmd, (err, stdout, stderr) ->
        assert.equal stdout, '<foo><bar>Titlul</bar>\n</foo>\n'
        assert.equal stderr, ''
        done err

    it 'without partial', (done) ->
      cmd =
        "echo \"{\\\"title\\\":\\\"Titlul\\\"}\" |
          coffee #{__dirname}/../lib/jsonrender_cmd.coffee
          --body #{__dirname}/template.mustache"
      exec cmd, (err, stdout, stderr) ->
        assert.equal stdout, '<bar>Titlul</bar>\n'
        assert.equal stderr, ''
        done err
