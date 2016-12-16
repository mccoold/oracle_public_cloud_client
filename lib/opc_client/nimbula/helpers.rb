class NimbulaHelpers < OpcClient
  module NimCommandLine
    # Request Handler is for command line calls, this method is used for all Nimbula network operations
    def request_handler(args) # rubocop:disable Metrics/AbcSize
      inputparse = InputParse.new(args)
      @options = inputparse.compute('networkclient')
      @options[:function] = @argsfunction if @argsfunction
      optparse
    end
  end
end