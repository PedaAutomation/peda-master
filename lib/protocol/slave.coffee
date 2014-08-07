logger = require '../logger'

InputCapability = require './inputCapability'
LogicCapability = require './logicCapability'
OutputCapability = require './outputCapability'

parseRegexFromJSON = (string) ->
  RegExp.apply(undefined, /^\/(.*)\/(.*)/.exec(string).slice(1))

class Slave
  constructor: (@ws) ->
    @inputCapabilities = []
    @logicCapabilities = []
    @outputCapabilities = []
    @name = @ws.id
  
  processMessage: (message) ->
    if not message.message?
      throw new Error("The message does not have any message.")
    
    
    switch message.message
      when "name" then @name = message.data
      when "capabilities" then @_handleMessageCapabilities(message.data)
      
  _handleMessageCapabilities: (data) ->
    self = this
    data.forEach (cap) ->
      switch cap.type
        when "input" then self._handleInputCapability(cap)
        when "logic" then self._handleLogicCapability(cap)
        when "output" then self._handleOutputCapability(cap)
      
      
  _handleInputCapability: (cap) ->
    capability = new InputCapability(cap.name)
    @inputCapabilities.push capability
    logger.info "Added Input Capability to Slave \"#{@name}\": \"#{capability.name}\""
    
  _handleLogicCapability: (cap) ->
    capability = new LogicCapability(cap.name, parseRegexFromJSON(cap.regex))
    @logicCapabilities.push capability
    logger.info "Added Logic Capabiity to Slave \"#{@name}\": \"#{capability.name}\""
    
  _handleOutputCapability: (cap) ->
    capability = new OutputCapability(cap.name, parseRegexFromJSON(cap.regex))
    @outputCapabilities.push capability
    logger.info "Added Output Capabiity to Slave \"#{@name}\": \"#{capability.name}\""
    
    

module.exports = Slave
