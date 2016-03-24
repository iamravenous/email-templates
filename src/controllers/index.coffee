# Just renders index.jade
jade = require('jade')
util = require('sf-jade-utils')
sass = require('node-sass')
juice = require('juice')
cheerio = require('cheerio')
Inky = require('inky').Inky

exports.index = (req, res) ->
	basepath = "#{process.env.PWD}/templates/#{req.params.template}"

	$ = cheerio.load(
		'<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<title>Documentoeprroko</title>
			<script src="http://localhost:35729/livereload.js"></script>
		</head>
			<body>
			</body>
		</html>'
	)

	content = "include mixins.jade\n"
	content += "include index.jade\n"

	bodyContent = jade.render(content, {
		filename: "#{basepath}/main.jade"
		pretty: "\t"
		u: util
	})

	$('body').append(bodyContent)

	compiledSass = sass.renderSync({
		file: "#{basepath}/styles.sass"
		includePaths: [
			"node_modules/foundation-emails/scss/"
		]
	})
	css = compiledSass.css.toString()
	$('head').append("<style>#{css}</style>")

	html = new Inky().releaseTheKraken($).html()
	
	res.send(juice(html,{
		preserveMediaQueries: true
	}))