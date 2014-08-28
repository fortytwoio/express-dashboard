path = require "path"
express = require "express"
cookieParser = require "cookie-parser"
session = require "cookie-session"
bodyParser = require "body-parser"
errorhandler = require "errorhandler"
morgan = require "morgan"
_ = require "lodash"

root = require.main.exports

getDebug = require "getdebug"
debug = getDebug __filename
app = exports = module.exports = express()

parentSettings = if root.settings then root.settings else {}
app.settings = _.assign app.settings, parentSettings
parentLocals = if root.locals then root.locals else {}
app.locals = _.assign app.locals, parentLocals

viewTemplateBaseDir = path.join __dirname, "..", "views", "templates"
viewBaseDir = path.join __dirname, "..", "views"
app.set "views", viewTemplateBaseDir
app.set "view engine", "jade"
app.set "trust proxy", true
app.locals.basedir = viewBaseDir # This will allow us to use absolute paths in jade when using the 'extends' directive

if "development" is app.get "env"
    debug "Setting development settings"
    app.locals.pretty = true # This will pretty print html output in development mode
    app.set "view cache", false
    app.use morgan("dev")
else
    debug "Setting production settings"
    app.locals.pretty = false
    app.set "view cache", true
    app.use morgan('combined')

# parse application/x-www-form-urlencoded
app.use bodyParser.urlencoded { extended : true }

# parse application/json
app.use bodyParser.json()

# parse application/vnd.api+json as json. http://jsonapi.org
app.use bodyParser.json({ type : 'application/vnd.api+json' })

app.use cookieParser()

sessionSettings = app.get "session"
app.use session {
    keys : [ sessionSettings.secret ]
    proxy : true
}
