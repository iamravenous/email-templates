express = require 'express'
session = require 'express-session'
flash = require 'connect-flash'
bodyParser = require 'body-parser'
compression = require 'compression'
cdPromise = require 'bluebird'

#### Config file
# Sets application config parameters depending on `env` name
exports.setEnvironment = (app,env) ->
	console.log "Current environment: #{env}"
	switch(env)
		when "development"
			exports.DEBUG_LOG = true
			exports.DEBUG_WARN = true
			exports.DEBUG_ERROR = true
			exports.DEBUG_CLIENT = true

		when "staging"
			exports.DEBUG_LOG = true
			exports.DEBUG_WARN = true
			exports.DEBUG_ERROR = true
			exports.DEBUG_CLIENT = true

		when "production"
			exports.DEBUG_LOG = false
			exports.DEBUG_WARN = false
			exports.DEBUG_ERROR = true
			exports.DEBUG_CLIENT = false

	# Global Middleware
	app.use session(
		resave: false
		saveUninitialized: true
		name: "session"
		secret: "thisisasecret"
		key: "sid"
	)

	app.use flash()
	app.use bodyParser()
	app.use(compression())

	app.set('view engine', 'jade')
