path        = require 'path'
modRewrite  = require 'connect-modrewrite'
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    clean:
      coverage:
        src:        ['src/**/*.js']
      public:
        src:        ['public/css/**/*', 'public/js/**/*', 'public/*.html', 'public/fonts/**']
        filter:     'isFile'

    copy:
      fonts:
        expand:   true
        cwd:      'public/components/font-awesome/fonts/'
        src:      '*'
        dest:     'public/fonts'
        filter:   'isFile'

    coffee:
      client:
        options:
          sourceMap: true
#          sourceRoot: 'coffee/'
        files: [
          expand:   true
          cwd:      'assets/coffee'
          src:      ['**/*.coffee']
          dest:     'public/js/'
          ext:      '.js'
        ]

    mochacov:
      coverage:
        options:
          require:        ['.codecov.js']
          coveralls:
            serviceName:  'travis-ci'
      client:
        options:
          reporter:   'spec'
          growl:      true
      options:
        recursive:    true
        files:        'test/spec/**/*-test.coffee'
        compilers:    ['coffee:coffee-script']

    stylus:
      assets:
        options:
          use: [
            require('nib')
          ]
          paths: [
            'public/'
          ]
          urlfunc:    'url',
          linenos:    true,
          'include css': true
        files:
          'public/css/main.css':      'assets/styl/main.styl'

    jade:
      client:
        options:
          amd: true
          namespace: false
          client: true
          compileDebug: false
          pretty: true
          processName: ( filename ) ->
            path.basename( filename ).split( '.' )[0]
        files:
          'public/js/templates/header.js':        'assets/tpl/header.jade'
          'public/js/templates/footer.js':        'assets/tpl/footer.jade'
          'public/js/templates/navigation.js':    'assets/tpl/navigation.jade'
          'public/js/templates/error.js':         'assets/tpl/error.jade'
          'public/js/templates/skeleton.js':      'assets/tpl/skeleton.jade'

          'public/js/templates/load.js':          'assets/tpl/load.jade'

          'public/js/templates/dump/select.js':      'assets/tpl/dump/select.jade'
          'public/js/templates/dump/item.js':      'assets/tpl/dump/item.jade'

          'public/js/templates/dumpinfo.js':      'assets/tpl/dumpinfo.jade'

          'public/js/templates/graph/contact.js':   'assets/tpl/graph/contact.jade'
          'public/js/templates/graph/message.js':   'assets/tpl/graph/message.jade'

          'public/js/templates/overview/index.js':      'assets/tpl/overview/index.jade'
          'public/js/templates/overview/shortstats.js':      'assets/tpl/overview/shortstats.jade'
          'public/js/templates/overview/topcontact.js':      'assets/tpl/overview/topcontact.jade'
          'public/js/templates/overview/timestats.js':      'assets/tpl/overview/timestats.jade'

          'public/js/templates/timeline/index.js':      'assets/tpl/timeline/index.jade'
          'public/js/templates/timeline/history.js':      'assets/tpl/timeline/history.jade'
          'public/js/templates/timeline/monthly.js':      'assets/tpl/timeline/monthly.jade'
          'public/js/templates/timeline/weekly.js':      'assets/tpl/timeline/weekly.jade'
          'public/js/templates/timeline/daily.js':      'assets/tpl/timeline/daily.jade'

          'public/js/templates/contact/index.js':      'assets/tpl/contact/index.jade'
          'public/js/templates/contact/bubble.js':      'assets/tpl/contact/bubble.jade'
          'public/js/templates/contact/top.js':      'assets/tpl/contact/top.jade'
          'public/js/templates/contact/special.js':      'assets/tpl/contact/special.jade'
          'public/js/templates/contact/log.js':      'assets/tpl/contact/log.jade'
          'public/js/templates/contact/details.js':      'assets/tpl/contact/details.jade'

          'public/js/templates/forensic/index.js':      'assets/tpl/forensic/index.jade'
          'public/js/templates/forensic/word-search.js':      'assets/tpl/forensic/word-search.jade'
          'public/js/templates/forensic/word-search-result.js':      'assets/tpl/forensic/word-search-result.jade'
          'public/js/templates/forensic/timestamp.js':      'assets/tpl/forensic/timestamp.jade'
          'public/js/templates/forensic/timestamp-result.js':      'assets/tpl/forensic/timestamp-result.jade'
          'public/js/templates/forensic/website.js':      'assets/tpl/forensic/website.jade'
          'public/js/templates/forensic/picturemap.js':      'assets/tpl/forensic/picturemap.jade'
          'public/js/templates/forensic/picturelist.js':      'assets/tpl/forensic/picturelist.jade'


      server:
        options:
          client: false
          pretty: true
          compileDebug: false
        files:
          'public/index.html':    'views/index.jade'

    requirejs:
      compile:
        options:
          preserveLicenseComments: false
          generateSourceMaps: false
          baseUrl: 'public/js'
          name: 'main'
          mainConfigFile: 'public/js/main.js'
          out: 'public/js/optimized.js'
          done: (done, output) ->
            duplicates = require('rjs-build-analysis').duplicates(output);
            if duplicates.length > 0
              grunt.log.subhead 'Duplicates found in requirejs build:'
              grunt.log.warn duplicates
              done new Error('r.js built duplicate modules, please check the excludes option.')
            else done()

    shell:
      coverage:
        command:    './node_modules/coffee-coverage/bin/coffeecoverage --initfile .codecov.js --exclude node_modules,Gruntfile.coffee,.git,test,assets --path relative . .'

    bower:
      client:
        rjsConfig:  'public/js/main.js'

    watch:
      client:
        files:      ['assets/styl/**/*.styl', 'assets/tpl/**/*.jade', 'assets/coffee/**/*.coffee']
        tasks:      ['stylus:assets', 'jade:client', 'coffee:client', 'bower:client']
        options:
          livereload: true

    connect:
      server:
        options:
          port: 9001
          base: 'public'
          keepalive: no
          debug: no
          middleware: (connect) ->
            return [
              modRewrite [
                '^/bower_components/(.*) /$1?bower [R]'
                '^/assets/(.*) /$1?asset [R]'
                '!\\.html|\\.js|\\.css|\\.png|\\.svg|\\.ttf|\\.woff|\\.map$ /index.html [L]'
              ]
              mountFolder connect, 'bower_components'
              mountFolder connect, 'assets'
              mountFolder connect, 'public'
            ]

    codo:
      options:
        title:  'forDASH API documentation'
        inputs: ['assets/coffee']


  grunt.registerTask 'build', [
    'clean:public', 'copy:fonts', 'coffee:client', 'stylus:assets', 'jade:client', 'jade:server'
  ]

  grunt.registerTask 'test', [
    'mochacov:client'
  ]

  grunt.registerTask 'travis', [
    'shell:coverage', 'mochacov:coverage', 'clean:coverage'
  ]

  grunt.registerTask 'doc', [
    'codo'
  ]

  grunt.registerTask 'dev', [
    'clean:public',  'newer:copy:fonts', 'stylus:assets', 'newer:jade:client', 'newer:jade:server',
    'newer:coffee:client', 'bower:client', 'connect:server', 'watch'
  ]
