{Console} = console

colors = require 'colors'

Mixto = require 'mixto'

class AConsole extends Mixto

  constructor: (@options={}) ->

    super

  extended: () ->

    _properties = () =>

      @options ?= {}

      @options.consoleThreshold ?= "error"

      @options.consoleColors ?= {

        error: "red"

        log: null

        info: "cyan"

        warn: "yellow"

        silent: null

      }

      @options.consoleLevels ?= {

        error: 0

        log: 1

        info: 2

        warn: 3

        silent: 999

      }

      @options.consoleOutputStream ?= process.stdout

      @options.consoleErrorStream ?= process.stderr

    _methods = () =>

      _console = new Console(

        @options.consoleOutputStream,

        @options.consoleErrorStream

      )

      _threshold = (level) =>

        threshold = level or "#{@options.consoleThreshold}"

        if typeof threshold is "string" and

        typeof @options.consoleLevels[threshold] isnt "undefined"

          @options.consoleThreshold = "#{threshold}"

          threshold = @options.consoleLevels[threshold]

        if typeof threshold isnt "number"

          throw new Error "invalid threshold #{threshold}"

        return threshold

      Object.keys(@options.consoleLevels).map (level) =>

        _console["_#{level}"] = _console[level]

        _console[level] = (args...) =>

          if @options.consoleLevels[level] >= _threshold()

            if color = @options.consoleColors[level]

              colors ?= require "colors"

              args = args.map (arg) ->

                if typeof arg isnt "string" then return arg

                return arg[color]

            _console["_#{level}"].apply _console, args

      Object.defineProperty @, "console",

        value: _console

    _extended = () =>

      _properties()

      _methods()

    _extended()

module.exports = AConsole
