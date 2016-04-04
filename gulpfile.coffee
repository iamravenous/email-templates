
gulp         = require("gulp")
coffee       = require("gulp-coffee")
watch        = require("gulp-watch")
livereload   = require("gulp-livereload")
notify       = require("gulp-notify")
plumber      = require("gulp-plumber")
nodemon      = require 'gulp-nodemon'

path = "./front"

files =
	dist: './dist'
	server:
		watch:        './src/**/*.coffee'
		dest:         './app'

gulp.task "default", ['build:server'], ->
	livereload.listen()
	watch "templates/**/*", -> 
		livereload.reload()

	nodemon
		script: 'server.js'
		ext: 'js'
		delay: 100
		watch: [
			'app/index.js'
		]
	return

gulp.task "dev", ['build:server'], ->
	livereload.listen({start:true})
	gulp.watch files.server.watch,   [ "build:server" ]
	gulp.watch "./templates/**/*", -> 
		livereload.reload()

	nodemon
		script: 'server.js'
		ext: 'js'
		delay: 100
		watch: [
			'app/index.js'
		]

	return

gulp.task "debug", ['build:server'], -> 	
	nodemon
		script: 'server.js'
		ext: 'js'
		delay: 100
		nodeArgs: ['--debug']
		watch: [
			'app/index.js'
		]
	return


gulp.task 'build:server', ->
	gulp.src([
		files.server.watch,
	])
		.pipe plumber(
			errorHandler: (error)->
				notify.onError('Server compilation error: <%= error.message %>')
				console.log('\n' + error.stack)
		)
		.pipe(coffee({
			bare: 'true'
		}))
		.pipe(gulp.dest(files.server.dest))
	return 