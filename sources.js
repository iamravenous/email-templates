var _ = require('lodash');

var sources = {
	js: [
		'bower_components/moment/moment.js',
		'bower_components/moment/locale/es.js',
		'bower_components/lodash/lodash.min.js',
		'bower_components/jquery/dist/jquery.js',
		'bower_components/angular/angular.js',
		'bower_components/angular-i18n/angular-locale_es-cl.js',
		'bower_components/angular-messages/angular-messages.js',
		'bower_components/angular-animate/angular-animate.js',
		'bower_components/angular-sanitize/angular-sanitize.js',
		'bower_components/angular-resource/angular-resource.js',
		'bower_components/angular-route/angular-route.js',
		'bower_components/angular-bootstrap/ui-bootstrap-tpls.js',
		'bower_components/ng-file-upload/ng-file-upload.js',
		'bower_components/color-thief/src/color-thief.js',
		'js/app.js',
		'js/app.templates.js',
	],
	css: [
		'css/main.css'
	],
	prependFullPath: function(){
		_.each( sources.js, function(item,i,arr){
			if( _.startsWith(item,'js/') ){
				arr[i] = 'front/' + item;
			}
		})
		_.each( sources.css, function(item,i,arr){
			if( _.startsWith(item,'css/') ){
				arr[i] = 'front/' + item;
			}
		})
	}
}

module.exports = sources;