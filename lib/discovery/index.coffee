mdns = require 'mdns'

ad = null

exports.init = (port, cb) ->
  console.log "Initializing Discovery."
  ad = mdns.createAdvertisement mdns.tcp('pedam'), port
  console.log "Discovery initialized."
  cb()

exports.start = ->
  console.log "Starting Discovery."
  if ad?
    ad.start()
  
