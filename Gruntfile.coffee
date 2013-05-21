# global module:false require:true
path = require 'path'

module.exports = (grunt) ->

  # Load tasks
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-handlebars')
  grunt.loadNpmTasks('grunt-contrib-jshint')
  grunt.loadNpmTasks('grunt-contrib-stylus')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-plato')

  # Project configuration.
  grunt.initConfig
    pkg: '<json:package.json>'
    meta:
      banner: """/*! <%= pkg.name %> - v<%= pkg.version %> -
        <%= grunt.template.today("yyyy-mm-dd") %>
         * https://github.com/AF83/koalab\n
         * Copyright (c) <%= grunt.template.today("yyyy") %>
        af83; Licensed MIT */"""
    clean: [
      'docs'
      'public/*.css'
      'public/*.js'
      'public/*.map'
      'public/*.coffee'
    ]
    jshint:
      front: ['assets/**/*.js']
      back: ['package.json', 'koalab.js', 'app/**/*.js']
    coffeelint:
      files: ['Gruntfile.coffee', 'assets/**/*.coffee']
    plato:
      front:
        files:
          'reports/front': [
            'assets/**/*.js'
            'public/templates.js'
            'public/app.js'
          ]
      back:
        files:
          'reports/back': ['koalab.js', 'app/**/*.js']
    coffee:
      options:
        sourceMap: true
      compile:
        files:
          'public/app.js': [
            'assets/app.coffee'
            'assets/source.coffee'
            'assets/helpers/*.coffee'
            'assets/models/*.coffee'
            'assets/collections/*.coffee'
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
          'public/templates.js': ['assets/templates/*.hbs']
    copy:
      js:
        files: [
          'public/keymaster.js': 'components/keymaster/keymaster.js'
          'public/json2.js': 'components/json2/json2.js'
          'public/handlebars.runtime.js':
            'components/handlebars/handlebars.runtime.js'
          'public/lodash.js': 'components/lodash/dist/lodash.underscore.js'
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
    uglify:
      dist:
        banner: '<banner:meta.banner>',
        files:
          'public/koalab.min.js': [
            'components/keymaster/keymaster.js'
            'components/json2/json2.js'
            'components/handlebars/handlebars.runtime.js'
            'components/lodash/dist/lodash.underscore.js'
            'components/backbone/backbone.js'
            'components/backbone.shortcuts/index.js'
            'public/templates.js'
            'public/app.js'
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
            'assets/css/persona-buttons.css'
            'components/normalize-css/normalize.css'
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
    'cssmin'
    'uglify'
  ]
