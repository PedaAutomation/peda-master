logger = require '../logger'

InputCapability = require './inputCapability'
LogicCapability = require './logicCapability'
OutputCapability = require './outputCapability'

EventEmitter = require('events').EventEmitter

parseRegexFromJSON = (string) ->
  RegExp.apply(undefined, /^\/(.*)\/(.*)/.exec(string).slice(1))

class Slave extends EventEmitter
  constructor: (@ws) ->
    @inputCapabilities = []
    @logicCapabilities = []
    @outputCapabilities = []
    @name = @ws.id
  
  hasOutputCapability: (name) ->
    ret = false
    @outputCapabilities.forEach (cap) ->
      ret = true if cap.name == name
    
    return ret
  
  processMessage: (message) ->
    if not message.message?
      throw new Error("The message does not have any message.")
    
    
    switch message.message
      when "name" then @name = message.data; logger.info "Slave \"#{@name}\" is with us!"
      when "capabilities" then @_handleMessageCapabilities(message.data)
      when "input" then @_handleMessageInput(message.data)
      when "forwardOutput" then @_handleMessageForwardOutput(message.data)

      
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
    logger.info "Added Logic Capability to Slave \"#{@name}\": \"#{capability.name}\""
    
  _handleOutputCapability: (cap) ->
    capability = new OutputCapability(cap.name)
    @outputCapabilities.push capability
    logger.info "Added Output Capability to Slave \"#{@name}\": \"#{capability.name}\""
    
    
  _handleMessageInput: (input) ->
    this.emit 'input', input
    
  _handleMessageForwardOutput: (data) ->
    this.emit 'outputForward', data
    
  
  sendHandleLogicMessage: (command) ->
    self = this
    @logicCapabilities.forEach (cap) ->
      if cap.respondsTo command.command
        logger.info "Sending Handle Logic to #{@name}."
        
        self.ws.send JSON.stringify ({ message: "handleLogic", data: { command: command, capability: cap.name }})
  
  handleCommand: (cmd) ->
    @sendHandleLogicMessage cmd
    
  handleOutput: (data) ->
    @ws.send JSON.stringify ({ message: "handleOutput", data: data})

module.exports = Slave
