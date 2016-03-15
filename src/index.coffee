require('dotenv').load({silent:true})

express = require 'express'


# Create app instance.
app = express()

# Define Port & Environment
app.port = process.env.PORT or process.env.VMC_APP_PORT or 3000
env = process.env.NODE_ENV or "development"

# Config depending on environment
config = require "./config"
config.setEnvironment(app,env)

# Initialize routers
#if env == 'development'
require('./router-api')(app)
require('./router')(app)

# Export application object
module.exports = app

