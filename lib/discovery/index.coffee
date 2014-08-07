logger = require '../logger'

mdns = require 'mdns'

ad = null

exports.init = (port, cb) ->
  logger.info "Initializing Discovery."
  ad = mdns.createAdvertisement mdns.tcp('pedam'), port
  logger.info "Discovery initialized."
  cb()

exports.start = ->
  logger.info "Starting Discovery."
  if ad?
    ad.start()
  logger.info "Discovery running."
  
exports.stop = ->
  if ad?
    ad.stop()
  ad = null
