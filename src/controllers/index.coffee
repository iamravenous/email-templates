# Just renders index.jade
jade = require('jade')
util = require('sf-jade-utils')
stylus = require('stylus')
juice = require('juice')

exports.index = (req, res) ->
	basepath = "#{process.env.PWD}/templates"

	content = "include cyt.jade\n"
	content += req.body.content
	body = jade.render(content, {
		filename: "#{basepath}/main.jade"
		pretty: "\t"
		u: util
	})

	css = stylus('').import("#{basepath}/cyt.styl").render()
	
	body+="<style>#{css}</style>"
	body = juice(body)
	
	res.send(body)