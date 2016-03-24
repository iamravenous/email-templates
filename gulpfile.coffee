
gulp         = require("gulp")
coffee       = require("gulp-coffee")
stylus       = require("gulp-stylus")
watch        = require("gulp-watch")
livereload   = require("gulp-livereload")
prefix       = require("gulp-autoprefixer")
notify       = require("gulp-notify")
plumber      = require("gulp-plumber")
jade         = require("gulp-jade")
uglify       = require("gulp-uglify")
csso         = require("gulp-csso")

concat       = require 'gulp-concat'
html2js      = require 'gulp-html2js'
nodemon      = require 'gulp-nodemon'
ngAnnotate   = require 'gulp-ng-annotate'
sourcemaps   = require 'gulp-sourcemaps'


sources = require './sources'
sources.prependFullPath()

path = "./front"

files =
	dist: './dist'
	jade:
		watch:        path + "/jade/**/*.jade"
		src:          path + "/jade/**/*.jade"
		dest:         path
	
	partials:
		watch:        path + "/partials/**/*.jade"
		src:          path + "/partials/**/*.jade"
		dest:         path + "/js"

	stylus:
		watch:        path + "/stylus/**/*.styl"
		src:          path + "/stylus/main.styl"
		dest:         path + "/css"

	coffee:
		watch:        path + "/coffee/**/*.coffee"
		src:          path + "/coffee/**/*.coffee"
		dest:         path + "/js"

	images:
		watch:        path + "/img_max/*"
		src:          path + "/img_max/*"
		dest:         path + "/img"

	server:
		watch:        './src/**/*.coffee'
		dest:         './app'

gulp.task "default", ['build:server'], ->
	livereload.listen()
	watch "templates/**/*", -> livereload()
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
		console.log 'wat'
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

gulp.task "build:css", ->
	gulp.src(files.stylus.src)
		.pipe(plumber(errorHandler: notify.onError("<%= error.message %>")))
		.pipe(stylus())
		.pipe(notify("Compiled: <%= file.relative %>"))
		.pipe(prefix())
		.pipe(csso())
		.pipe(gulp.dest(files.stylus.dest))
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


gulp.task 'build:coffee', ->
	gulp.src([
		path + '/coffee/shared-app.coffee',
		path + '/coffee/app.coffee',
		path + '/coffee/config/**/*.coffee',
		path + '/coffee/controllers/**/*.coffee',
		path + '/coffee/directives/**/*.coffee',
		path + '/coffee/filters/**/*.coffee',
		path + '/coffee/services/**/*.coffee'
	])
		.pipe plumber(
			errorHandler: (error)->
				notify.onError('Coffeescript error: <%= error.message %>')
				console.log('\n' + error.stack)
		)
		.pipe(sourcemaps.init())
		.pipe(concat('app.js'))
		.pipe(coffee())
		.pipe(sourcemaps.write())
		.pipe(ngAnnotate())
		.pipe(gulp.dest(files.coffee.dest))
		.pipe(notify('Coffee compiled'))
	return 

gulp.task 'build:templates', ->
	gulp.src(files.partials.src)
		.pipe plumber(
			errorHandler: notify.onError('Templates error: <%= error.message %>')
		)
		.pipe(jade())
		.pipe(html2js({
			base: path
			outputModuleName: 'app.templates'
		}))
		.pipe(concat('app.templates.js'))
		.pipe(gulp.dest(files.partials.dest))
		.pipe(notify('Templates compiled'))
	return

gulp.task "bundle", ->
	gulp.src(sources.css)
		.pipe plumber(
			errorHandler: notify.onError('Error: <%= error.message %>')
		)
		.pipe(concat('styles.min.css'))
		.pipe(csso())
		.pipe(gulp.dest(files.dist + '/resources'))
	
	gulp.src(sources.js)
		.pipe plumber(
			errorHandler: notify.onError('Error: <%= error.message %>')
		)
		.pipe(concat('bundle.min.js'))
		.pipe(uglify({
			mangle: false
		}))
		.pipe(gulp.dest(files.dist + '/resources'))

	gulp.src(files.images.dest + '/**/*')
		.pipe(gulp.dest(files.dist + '/img'))

	return

