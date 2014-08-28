###
GET     /                 ->  exports.index
GET     /new              ->  exports.new
POST    /                 ->  exports.create
GET     /:id              ->  exports.show
GET     /:id/edit         ->  exports.edit
PUT     /:id              ->  exports.update
DELETE  /:id              ->  exports.destroy
###

getDebug = require 'getdebug'
debug = getDebug __filename

exports.index = (request, response) ->
    debug "Requested index", response.locals
    response.render "index"

exports.new = (request, response) ->
    debug "Requested index/new"
    response.render "index/new"
