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


	content = "include mixins.jade\n"
	content += "include index.jade\n"

	bodyContent = jade.render(content, {
		filename: "#{basepath}/main.jade"
		u: util
	})

	$ = cheerio.load(bodyContent)

	compiledSass = sass.renderSync({
		file: "#{basepath}/styles.scss"
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
