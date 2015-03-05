describe 'AConsole', () ->

  it 'before', () ->

    kosher.alias 'fixture', kosher.spec.fixtures.console

    kosher.alias 'instance', new kosher.fixture.A

		kosher.alias 'consoleLevels', [

      "error", "log", "info", "warn", "silent"

    ]

	describe 'properties', () ->

    describe 'consoleLevels', () ->

      it 'shoud have default values for each level', () ->

        consoleLevels = kosher.instance.options.consoleLevels

        Object.keys(consoleLevels).should.eql kosher.consoleLevels

    describe 'consoleColors', () ->

      it 'shoud have default values for each level', () ->

        consoleColors = kosher.instance.options.consoleColors

        Object.keys(consoleColors).should.eql kosher.consoleLevels

    describe 'consoleOutputStream / consoleErrorStream', () ->

      it 'should allow "stdout" and "stderr" stream overrides', (done) ->

        kosher.alias 'stream', new kosher.WriteableStream

        kosher.alias 'instance', new kosher.fixture.A

          consoleOutputStream: kosher.stream

          consoleErrorStream: kosher.stream

        kosher.stream.once "data", () ->

          done()

        kosher.instance.console.log "data"

    describe 'consoleThreshold', () ->

      it 'should default to error', () ->

        kosher.instance.options.consoleThreshold.should.eql "error"

      it 'should control the console verbosity', () ->

    describe 'console', () ->

      it 'before', () ->

        instance = kosher.instance

        kosher.alias 'instance', kosher.instance.console

        kosher.methods kosher.consoleLevels

        kosher.alias 'instance', instance

      it 'should have be able to log in color', (done) ->

        results = []

        lvls = ["info", "warn", "error"]

        kosher.stream.on "data", (data) ->

          results.push data

          if lvls.length is 0

            kosher.stream.end()

        kosher.stream.on "end", () ->

          kosher.stream.removeAllListeners()

          results.should.eql [
            "\u001b[36minfo\u001b[39m\n",
            "\u001b[33mwarn\u001b[39m\n",
            "\u001b[31merror\u001b[39m\n"
          ]

          done()

        while level = lvls.shift()

          kosher.instance.console[level] level

      it 'should allow verbosity control'
