mdns = require 'mdns'

ad = null

exports.init = (port) ->
  ad = mdns.createAdvertisement mdns.tcp('pedam'), port

exports.start = ->
  if ad?
    ad.start()
  
