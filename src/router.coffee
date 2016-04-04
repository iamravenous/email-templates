express = require 'express'
IndexController = require './controllers/index'

env = process.env.NODE_ENV or "development"

module.exports = (app)->
	router = new express.Router()

	# Middleware
	if env == "development"
		router.use('/bower_components',express.static('bower_components'))
		router.use(express.static('front'))
	else
		router.use(express.static('dist'))

	router.use (req,res,next)->
		res.locals.env = env
		res.locals.base_url = process.env.BASE_URL
		next()

	# Routes
	router.get '/:template', IndexController.index

	router.use (req,res,next)->
		res.status(404).render('404')

	router.use (err,req,res,next)->
		console.log err
		console.log err.stack
		next()

	router.use (err,req,res,next)->
		res.status(500).send(err)

	app.use('/', router)
