# global module:false require:true
path = require 'path'

module.exports = (grunt) ->

  # Load tasks
  grunt.loadNpmTasks('grunt-contrib')
  grunt.loadNpmTasks('grunt-coffeelint')

  # Project configuration.
  grunt.initConfig
    pkg: '<json:package.json>'
    meta:
      banner: """/*! <%= pkg.name %> - v<%= pkg.version %> -
        <%= grunt.template.today("yyyy-mm-dd") %>
         * https://github.com/AF83/koalab\n
         * Copyright (c) <%= grunt.template.today("yyyy") %>
        af83; Licensed MIT */"""
    clean: ['docs', 'tmp/*', 'public/*.css', 'public/*.js']
    jshint:
      front: ['assets/**/*.js']
      back: ['package.json', 'koalab.js', 'app/**/*.js']
    coffeelint:
      files: ['Gruntfile.coffee', 'assets/**/*.coffee']
    coffee:
      compile:
        files:
          'tmp/app.js': [
            'assets/app.coffee',
            'assets/source.coffee',
            'assets/helpers/*.coffee',
            'assets/models/*.coffee',
            'assets/collections/*.coffee',
            'assets/views/*.coffee'
          ]
    handlebars:
      compile:
        options:
          wrapped: true
          namespace: 'JST'
          processName: (filename) ->
            path.basename(filename, '.hbs')
        files:
          'tmp/templates.js': ['assets/templates/*.hbs']
    copy:
      js:
        files: [
          'public/keymaster.js': 'components/keymaster/keymaster.js'
          'public/json2.js': 'components/json2/json2.js'
          'public/handlebars.runtime.js':
            'components/handlebars/handlebars.runtime.js'
          'public/lodash.js': 'components/lodash/lodash.js'
          'public/backbone.js': 'components/backbone/backbone.js'
          'public/backbone.shortcuts.js':
            'components/backbone.shortcuts/index.js'
          'public/login.js': 'assets/js/login.js'
          'public/index.js': 'assets/js/index.js'
        ]
      css:
        files:
          'public/persona-buttons.css': 'assets/css/persona-buttons.css'
          'public/normalize.css': 'components/normalize-css/normalize.css'
    concat:
      dist:
        src: ['<banner:meta.banner>', 'tmp/app.js', 'tmp/templates.js']
        dest: 'public/koalab.js'
    uglify:
      dist:
        banner: '<banner:meta.banner>',
        files:
          'public/koalab.min.js': [
            'components/keymaster/keymaster.js',
            'components/json2/json2.js',
            'components/handlebars/handlebars.runtime.js',
            'components/lodash/lodash.js',
            'components/backbone/backbone.js',
            'components/backbone.shortcuts/index.js',
            '<%= concat.dist.dest %>'
          ]
      zepto:
        files:
          'public/zepto.min.js': ['components/zepto/zepto.js']
    stylus:
      compile:
        files:
          'public/koalab.css': 'assets/css/*.styl'
    cssmin:
      dist:
        files:
          'public/koalab.min.css': [
            'assets/css/persona-buttons.css',
            'components/normalize-css/normalize.css',
            'public/koalab.css'
          ]
    watch:
      files: [
        '<%= coffeelint.files %>'
        'assets/templates/*.hbs'
        'assets/css/*.styl'
      ]
      tasks: [
        'coffeelint'
        'stylus'
        'handlebars'
        'coffee'
        'concat'
      ]

  # Default task.
  grunt.registerTask 'default', [
    'jshint'
    'coffeelint'
    'clean'
    'stylus'
    'handlebars'
    'coffee'
    'copy'
    'concat'
    'cssmin'
    'uglify'
  ]
