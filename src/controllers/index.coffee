# Just renders index.jade
jade = require('jade')
util = require('sf-jade-utils')
sass = require('node-sass')
juice = require('juice')
cheerio = require('cheerio')
Inky = require('inky').Inky
minify = require('html-minifier').minify

exports.index = (req, res) ->
	basepath = "#{process.env.PWD}/templates/#{req.params.template}"

	$ = cheerio.load(
		'<!DOCTYPE html>
		<html lang="en">
		<head>
			<title>Email</title>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<meta name="viewport" content="width=device-width"/>
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

	inlined = juice(html,{
		preserveMediaQueries: true
	})

	return res.send(minify(inlined,{
		minifyCSS: true
		collapseWhitespace: true
	}))