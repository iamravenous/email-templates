express = require 'express'
_ = require 'lodash'
middleware = require './middleware'

env = process.env.NODE_ENV or "development"

module.exports = (app)->
	router = new express.Router()


	router.get '/test', (req,res,next)->
		res.send
			status: 'OK'
		

	
	# GET API ROUTES ( INDEX / GET )
	router.all '/:controller/:id*?', (req, res, next) ->
		try
			controller = require "./controllers/#{req.params.controller}"
		catch err     
			console.log "Controller #{req.params.controller} not found"
			next()
		
		controllerMethod = null
		switch req.method
			# INDEX / GET
			when 'GET'
				if req.params.id?
					controllerMethod = controller.get
				else
					controllerMethod = controller.index
			
			# CREATE / UPDATE
			when 'POST'
				if req.params.id?
					controllerMethod = controller.update
				else
					controllerMethod = controller.create
			
			# DELETE
			when 'DELETE'
				controllerMethod = controller.delete

		if ! controllerMethod
			next('Controller method not found')
		else
			controllerMethod(req,res,next)


	router.use (req,res,next)->
		res.status(404).send({message:'Unknown endpoint'})

	router.use (err,req,res,next)->
		message = {}
		res.status(500)
		switch typeof err
			when 'string'
				message.error = err
			else
				message.error = err.message
				
				if env != 'production'
					message.stack = err.stack

				if err.status
					res.status(err.status)

		console.log(message.error,message.stack)
		res.send(message)

	app.use('/api', router)