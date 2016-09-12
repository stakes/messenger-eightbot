module.exports = (grunt) ->
  grunt.initConfig
    express:
      dev:
        options:
          script: 'target/app.js'
    coffee:
      compile:
        files: [
          expand: true
          cwd: 'src'
          src: '**/*.coffee'
          dest: 'target'
          ext: '.js'
        ]
    coffeelint:
      app: 'src/**/*.coffee'
    watch:
      coffeescript:
        files: ['Gruntfile.coffee', 'src/**/*.coffee']
        tasks: ['coffeelint', 'coffee']
      express:
        files: ['src/app.coffee']
        tasks: ['express:dev']
        options:
          spawn: false
      
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express-server'

  grunt.registerTask 'default', ['express:dev', 'watch']
