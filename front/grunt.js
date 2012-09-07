/*global module:false require:true*/
var path = require('path');

module.exports = function(grunt) {

  // Load tasks
  grunt.loadNpmTasks('grunt-contrib');
  grunt.loadNpmTasks('grunt-coffeelint');

  // Project configuration.
  grunt.initConfig({
    meta: {
      version: '0.1.0',
      banner: '/*! Boardz - v<%= meta.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        ' * https://github.com/AF83/boardz\n' +
        ' * Copyright (c) <%= grunt.template.today("yyyy") %> ' +
        'af83; Licensed MIT */'
    },
    clean: ["docs", "tmp/*", "public/*.css", "public/*.js"],
    lint: {
      files: ['grunt.js']
    },
    coffeelint: {
      files: ['app/**/*.coffee']
    },
    coffee: {
      compile: {
//         options: {
//           bare: true
//         },
        files: {
          "tmp/app.js": ["app/app.coffee", "app/models/*.coffee", "app/collections/*.coffee", "app/views/*.coffee"]
        }
      }
    },
    handlebars: {
      compile: {
        options: {
          namespace: "JST",
          processName: function(filename) {
            return path.basename(filename, ".hbs");
          }
        },
        files: {
          "tmp/templates.js": ["app/templates/*.hbs"]
        }
      }
    },
    copy: {
      dev: {
        files: {
          "public": "vendor/*"
        }
      }
    },
    concat: {
      dist: {
        src: ['<banner:meta.banner>', 'tmp/app.js', 'tmp/templates.js'],
        dest: 'public/boardz.js'
      }
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', 'vendor/**/*.js', '<config:concat.dist.dest>'],
        dest: 'public/boardz.min.js'
      }
    },
    server: {
      port: 8000,
      base: 'public'
    },
    uglify: {},
    stylus: {
      compile: {
        files: {
          'public/boardz.css': 'app/css/*.styl'
        }
      }
    },
    watch: {
      files: ['<config:coffeelint.files>', 'app/templates/*.hbs', 'app/css/*.styl'],
      tasks: 'coffeelint stylus handlebars coffee concat'
    }
  });

  // Default task.
  grunt.registerTask('default', 'lint coffeelint clean stylus handlebars coffee copy concat');

};
