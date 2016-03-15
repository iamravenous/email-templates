# Just renders index.jade
jade = require('jade')
util = require 'sf-jade-utils'

exports.index = (req, res) ->
	console.log '?????'
	content = "include templates/cyt.jade\n"
	content += "+base()\n"
	console.log req.body
	content += req.body.content
	body = jade.render(content,{filename:'/var/www/html/email-templates/templates/'})
	res.send(body)