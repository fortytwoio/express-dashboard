crypto = require "crypto"
getDebug = require "getdebug"
debug = getDebug __filename
pathToRegexp = require "path-to-regexp"

getMd5 = (string) ->
    string = string || ""
    string = string.trim().toLowerCase()
    md5Sum = crypto.createHash "md5"
    md5Sum.update string
    return md5Sum.digest "hex"

getGravatar = (email) ->
    return "https://secure.gravatar.com/avatar/#{getMd5(email)}?"

isActive = (request) ->
    active = (urlPath) ->
        if !urlPath then return false
        keys = []
        paths = []
        if request.baseUrl
            paths.push request.baseUrl
        if request.route.path != '/'
            paths.push request.route.path
        routePath = paths.join ""
        regex = pathToRegexp routePath, keys, { sensitive : false, strict : false }
        matches = urlPath.match regex
        debug "match?", (null != matches), regex, keys, urlPath, routePath
        return (null != matches)
    return active

module.exports = (request, response, next) ->
    response.locals.baseurl = request.baseUrl
    response.locals.request = request
    response.locals.isActive = isActive(request)
    response.locals.md5 = getMd5
    response.locals.gravatar = getGravatar
    next()
