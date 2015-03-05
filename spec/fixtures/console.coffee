kosher.alias 'AConsole'

class Console

  constructor: (@options) ->

    kosher.AConsole.extend @

class A extends Console

module.exports =

  "A": A
