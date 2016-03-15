module.exports = 
	auth: (req,res,next)->
		if req.isAuthenticated()
			return next()
		else
			req.flash('error','Debes estar logeado para acceder a esta página.')
			res.redirect('/login')

	apiAuth: (req,res,next)->
		if req.isAuthenticated()
			return next()
		else
			return next('No tienes acceso a este recurso.')