// Generated on 2015-04-19 using generator-chrome-extension 0.3.1
'use strict';

// # Globbing
// for performance reasons we're only matching one level down:
// 'test/spec/{,*/}*.js'
// use this if you want to recursively match all subfolders:
// 'test/spec/**/*.js'

module.exports = function (grunt) {

  // Load grunt tasks automatically
  require('load-grunt-tasks')(grunt);

  // Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt);

  // Configurable paths
  var config = {
    app: 'app',
    dist: 'dist'
  };

  grunt.initConfig({

    // Project settings
    config: config,

    // Watches files for changes and runs tasks based on the changed files
    watch: {
      bower: {
        files: ['bower.json'],
        tasks: ['bowerInstall']
      },
      coffee: {
        files: ['<%= config.app %>/coffee/**/*.{coffee,litcoffee,coffee.md}'],
        // files: ['<%= config.app %>/scripts/{,*/}*.{coffee,litcoffee,coffee.md}'],
        tasks: ['coffee:chrome', 'chromesourceurl:chrome'],
        options: {
          spawn: false,
          livereload: '<%= connect.options.livereload %>'
        }
      },

      // sourceurl: {
      //   files: ['<%= config.app %>/coffee/**/*.{coffee,litcoffee,coffee.md}'],
      //   // files: ['<%= config.app %>/scripts/{,*/}*.{coffee,litcoffee,coffee.md}'],
      //   tasks: ['sourceurl:chrome']
      // },
      // requirejs_contentscript: {
      //   files: ['<%= config.app %>/{,*/}*.js', '!<%= config.app %>/scripts/contentscript_src.js'],
      //   tasks: ['requirejs:chrome'],
      //   options: {
      //     livereload: '<%= connect.options.livereload %>'
      //   }
      // },
      gruntfile: {
        files: ['Gruntfile.js']
      },
      styles: {
        files: ['<%= config.app %>/styles/{,*/}*.css'],
        tasks: [],
        options: {
          livereload: '<%= connect.options.livereload %>'
        }
      },
      livereload: {
        options: {
          livereload: '<%= connect.options.livereload %>'
        },
        files: [
          '<%= config.app %>/*.html',
          '<%= config.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}',
          '<%= config.app %>/manifest.json',
          '<%= config.app %>/_locales/{,*/}*.json'
        ]
      },
      notify: {
        files: ['<%= config.app %>/**/*'],
        tasks: ['notify:watch'],
      }
    },

    requirejs: {
      chrome: {
        options: {
          optimize: 'none',
          // generateSourceMaps: true,
          generateSourceMaps: false,
          baseUrl: "app/scripts",
          mainConfigFile: "app/contentscript_config.js",
          name: "../bower_components/almond/almond",
          include: ['contentscript_src'],
          out: "app/scripts/contentscript.js"
        }
      },
      dist: {
        options: {
          optimize: 'none',
          // generateSourceMaps: true,
          generateSourceMaps: false,
          baseUrl: "app/scripts",
          mainConfigFile: "app/contentscript_config.js",
          name: "../bower_components/almond/almond",
          include: ['contentscript_src'],
          out: "app/scripts/contentscript.js"
        }
      }
    },
    notify_hooks: {
      options: {
        // enabled: true,
        // max_jshint_notifications: 5, // maximum number of notifications from jshint output
        // title: "Project Name", // defaults to the name in package.json, or will use project directory's name
        success: true, // whether successful grunt executions should be notified automatically
        duration: 3 // the duration of notification in seconds, for `notify-send only
      }
    },
    notify: {
      watch: {
        options: {
          title: 'Watch Complete',  // optional
          message: 'Extenstion is ready!', //required
        }
      },
      server: {
        options: {
          message: 'Server is ready!'
        }
      }
    },

    // sourceurl: {
    //   chrome: {
    //     src: '<%= config.app %>/scripts/**/*',
    //     basePath: '<%= config.app %>/scripts'  // all the sourceURLs will be relative to this directory
    //   },
    // },

    chromesourceurl: {
      chrome: {
        src: '<%= config.app %>/scripts/**/*',
        basePath: '<%= config.app %>/scripts'  // all the sourceURLs will be relative to this directory
      },
    },

    // Grunt server and debug server setting
    connect: {
      options: {
        port: 9000,
        livereload: 35729,
        // change this to '0.0.0.0' to access the server from outside
        hostname: 'localhost'
      },
      chrome: {
        options: {
          open: false,
          base: [
            '<%= config.app %>'
          ]
        }
      },
      test: {
        options: {
          open: false,
          base: [
            'test',
            '<%= config.app %>'
          ]
        }
      }
    },

    // Empties folders to start fresh
    clean: {
      chrome: {
      },
      dist: {
        files: [{
          dot: true,
          src: [
            '<%= config.dist %>/*',
            '!<%= config.dist %>/.git*'
          ]
        }]
      }
    },

    // Make sure code styles are up to par and there are no obvious mistakes
    jshint: {
      options: {
        jshintrc: '.jshintrc',
        reporter: require('jshint-stylish')
      },
      all: [
        'Gruntfile.js',
        '<%= config.app %>/scripts/{,*/}*.js',
        '!<%= config.app %>/scripts/vendor/*',
        'test/spec/{,*/}*.js'
      ]
    },
    mocha: {
      all: {
        options: {
          run: true,
          urls: ['http://localhost:<%= connect.options.port %>/index.html']
        }
      }
    },

    // Compiles CoffeeScript to JavaScript
    coffee: {
      chrome: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>/coffee',
          // src: '{,*/}*.{coffee,litcoffee,coffee.md}',
          src: '**/*.{coffee,litcoffee,coffee.md}',
          dest: '<%= config.app %>/scripts',
          ext: '.js'
        }]
      },
      dist: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>/coffee',
          // src: '{,*/}*.{coffee,litcoffee,coffee.md}',
          src: '**/*.{coffee,litcoffee,coffee.md}',
          dest: '<%= config.app %>/scripts',
          ext: '.js'
        }]
      },
      test: {
        files: [{
          expand: true,
          cwd: 'test/spec',
          // src: '{,*/}*.coffee',
          src: '**/*.coffee',
          dest: './spec',
          ext: '.js'
        }]
      }
    },

    // Automatically inject Bower components into the HTML file
    bowerInstall: {
      app: {
        src: [
          '<%= config.app %>/*.html'
        ]
      }
    },

    // Reads HTML for usemin blocks to enable smart builds that automatically
    // concat, minify and revision files. Creates configurations in memory so
    // additional tasks can operate on them
    useminPrepare: {
      options: {
        dest: '<%= config.dist %>'
      },
      html: [
        '<%= config.app %>/popup.html',
        '<%= config.app %>/options.html'
      ]
    },

    // Performs rewrites based on rev and the useminPrepare configuration
    usemin: {
      options: {
        assetsDirs: ['<%= config.dist %>', '<%= config.dist %>/images']
      },
      html: ['<%= config.dist %>/{,*/}*.html'],
      css: ['<%= config.dist %>/styles/{,*/}*.css']
    },

    // The following *-min tasks produce minifies files in the dist folder
    imagemin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>/images',
          src: '{,*/}*.{gif,jpeg,jpg,png}',
          dest: '<%= config.dist %>/images'
        }]
      }
    },

    svgmin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>/images',
          src: '{,*/}*.svg',
          dest: '<%= config.dist %>/images'
        }]
      }
    },

    htmlmin: {
      dist: {
        options: {
          // removeCommentsFromCDATA: true,
          // collapseWhitespace: true,
          // collapseBooleanAttributes: true,
          // removeAttributeQuotes: true,
          // removeRedundantAttributes: true,
          // useShortDoctype: true,
          // removeEmptyAttributes: true,
          // removeOptionalTags: true
        },
        files: [{
          expand: true,
          cwd: '<%= config.app %>',
          src: '*.html',
          dest: '<%= config.dist %>'
        }]
      }
    },

    // By default, your `index.html`'s <!-- Usemin block --> will take care of
    // minification. These next options are pre-configured if you do not wish
    // to use the Usemin blocks.
    // cssmin: {
    //   dist: {
    //     files: {
    //       '<%= config.dist %>/styles/main.css': [
    //         '<%= config.app %>/styles/{,*/}*.css'
    //       ]
    //     }
    //   }
    // },
    // uglify: {
    //   dist: {
    //     files: {
    //       '<%= config.dist %>/scripts/scripts.js': [
    //         '<%= config.dist %>/scripts/scripts.js'
    //       ]
    //     }
    //   }
    // },
    // concat: {
    //   dist: {}
    // },

    // Copies remaining files to places other tasks can use
    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= config.app %>',
          dest: '<%= config.dist %>',
          src: [
            '*.{ico,png,txt}',
            'images/{,*/}*.{webp,gif}',
            '{,*/}*.html',
            'styles/{,*/}*.css',
            'styles/fonts/{,*/}*.*',
            '_locales/{,*/}*.json',
          ]
        }]
      }
    },

    // Run some tasks in parallel to speed up build process
    concurrent: {
      chrome: [
        'coffee:chrome',
      ],
      dist: [
        'coffee:dist',
        'imagemin',
        'svgmin'
      ],
      test: [
        'coffee:test',
      ]
    },

    // Auto buildnumber, exclude debug files. smart builds that event pages
    chromeManifest: {
      dist: {
        options: {
          // buildnumber: true,
          indentSize: 2,
          background: {
            target: 'scripts/background.js',
            exclude: [
              'scripts/chromereload.js'
            ]
          }
        },
        src: '<%= config.app %>',
        dest: '<%= config.dist %>'
      }
    },

    // Compres dist files to package
    compress: {
      dist: {
        options: {
          archive: function() {
            var manifest = grunt.file.readJSON('app/manifest.json');
            return 'package/OhSnapNetflix-' + manifest.version + '.zip';
          }
        },
        files: [{
          expand: true,
          cwd: 'dist/',
          src: ['**'],
          dest: ''
        }]
      }
    }
  });

  // adding sourceUrl comment to js files
  grunt.registerMultiTask('chromesourceurl', 'Appends a //@ sourceURL=... comment to source files that will survive compilation and source maps', function() {
    var path = require('path');
    var that = this;
    this.files.forEach(function(file) {

      //file.src is the list of all matching file names.
      file.src.forEach(function(src){

        // var sourceUrl = path.relative(that.data.basePath, src);
        // var sourceUrl = path.basename(src);
        var sourceUrl = src;

        // sourceUrl = "\n###\n//@ sourceURL=#{sourceUrl}\n###"

        sourceUrl = "\n//# sourceURL="+sourceUrl;
        var ext   = path.extname(src);

        if (ext === '.js'){
          var content     = grunt.file.read(src);
          // write sourceUrl comment to all js files without it
          if (content.indexOf(sourceUrl) === -1){
            grunt.file.write(src, grunt.file.read(src) + sourceUrl);
          }
        }
      });
    });
  });

  grunt.registerTask('debug', function () {
    grunt.task.run([
      'jshint',
      'concurrent:chrome',
      'connect:chrome',
      'requirejs:chrome',
      'watch'
    ]);
  });

  grunt.registerTask('test', [
    'connect:test',
    'mocha'
  ]);

  grunt.registerTask('build', [
    'clean:dist',
    'chromeManifest:dist',
    'useminPrepare',
    'concurrent:dist',
    'requirejs:dist',
    'cssmin',
    'concat',
    'uglify',
    'copy',
    'usemin',
    'compress'
  ]);

  grunt.registerTask('default', [
    'jshint',
    'test',
    'build'
  ]);

  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-notify');
  // grunt.loadNpmTasks('grunt-coffeescript-sourceurl');

};
