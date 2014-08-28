module.exports = (request, response, next) ->
    request.session.messages = request.session.messages or []
    response.locals.messages = request.session.messages.splice(0)
    next()
