/*global module:false require:true*/
var path = require('path');

module.exports = function(grunt) {

  // Load tasks
  grunt.loadNpmTasks('grunt-contrib');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-shell-completion');

  // Project configuration.
  grunt.initConfig({
    pkg: '<json:package.json>',
    meta: {
      banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        ' * https://github.com/AF83/koalab\n' +
        ' * Copyright (c) <%= grunt.template.today("yyyy") %> ' +
        'af83; Licensed MIT */'
    },
    clean: ['docs', 'tmp/*', 'public/*.css', 'public/*.js'],
    lint: {
      files: ['grunt.js']
    },
    coffeelint: {
      files: ['assets/**/*.coffee']
    },
    coffee: {
      compile: {
        files: {
          'tmp/app.js': [
            'assets/app.coffee',
            'assets/source.coffee',
            'assets/helpers/*.coffee',
            'assets/models/*.coffee',
            'assets/collections/*.coffee',
            'assets/views/*.coffee'
          ]
        }
      }
    },
    handlebars: {
      compile: {
        options: {
          wrapped: true,
          namespace: 'JST',
          processName: function(filename) {
            return path.basename(filename, '.hbs');
          }
        },
        files: {
          'tmp/templates.js': ['assets/templates/*.hbs']
        }
      }
    },
    copy: {
      js: {
        files: {
          'public/keymaster.js': 'components/keymaster/keymaster.js',
          'public/json2.js': 'components/json2/json2.js',
          'public/handlebars.runtime.js': 'components/handlebars/handlebars.runtime.js',
          'public/lodash.js': 'components/lodash/lodash.js',
          'public/backbone.js': 'components/backbone/backbone.js',
          'public/backbone.shortcuts.js': 'components/backbone.shortcuts/index.js',
          'public/login.js': 'assets/js/login.js',
          'public/login.js': 'assets/js/login.js'
        }
      },
      css: {
        files: {
          'public/persona-buttons.css': 'assets/css/persona-buttons.css',
          'public/normalize.css': 'components/normalize-css/normalize.css'
        }
      }
    },
    concat: {
      dist: {
        src: ['<banner:meta.banner>', 'tmp/app.js', 'tmp/templates.js'],
        dest: 'public/koalab.js'
      }
    },
    min: {
      dist: {
        src: [
          '<banner:meta.banner>',
          'components/keymaster/keymaster.js',
          'components/json2/json2.js',
          'components/handlebars/handlebars.runtime-1.0.0-rc.1.js',
          'components/lodash/lodash.js',
          'components/backbone/backbone.js',
          'components/backbone.shortcuts/index.js',
          '<config:concat.dist.dest>'
        ],
        dest: 'public/koalab.min.js'
      },
      zepto: {
        src: ['components/zepto/index.js'],
        dest: 'public/zepto.min.js'
      }
    },
    uglify: {},
    stylus: {
      compile: {
        files: {
          'public/koalab.css': 'assets/css/*.styl'
        }
      }
    },
    mincss: {
      dist: {
        files: {
          'public/koalab.min.css': [
            'assets/css/persona-buttons.css',
            'components/normalize-css/normalize.css',
            'public/koalab.css'
          ]
        }
      }
    },
    watch: {
      files: ['<config:coffeelint.files>', 'assets/templates/*.hbs', 'assets/css/*.styl'],
      tasks: 'coffeelint stylus handlebars coffee concat'
    }
  });

  // Default task.
  grunt.registerTask('default', 'lint coffeelint clean stylus handlebars coffee copy concat mincss min');

};
