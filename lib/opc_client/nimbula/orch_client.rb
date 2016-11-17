# Author:: Daryn McCool (<mdaryn@hotmail.com>)

# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIE S OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# This class controls Nimbula orchestrations, 
# when calling this class you will need to set :options, :util, and orch
# i.e. 
# require OPC
# @util = Utilities.new  
# before calling any of the action classes
class OrchClient < NimbulaClient
  # this is the method for when being called from command line
  # you would not call this method directly
  
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    @options = inputparse.compute('orch')
    attrcheck = { 'Action'        => @options[:action],
                  'REST endpoint' => @options[:rest_endpoint] }
    @validate = Validator.new
    @util = Utilities.new
    @validate.attrvalidate(@options, attrcheck)
    @orch = Orchestration.new(@options)
    case @options[:action]
    when 'create', 'update', 'delete'
      attrcheck = { 'create_json' => @options[:create_json] } unless @options[:action].downcase == 'delete'
      attrcheck = { 'orch Container' => @options[:container] } if @options[:action].downcase == 'delete'
      @validate.attrvalidate(@options, attrcheck)
      update
    when 'list', 'details'
      attrcheck = { 'Container' => @options[:container] }
      @validate.attrvalidate(@options, attrcheck)
      list
    when 'start', 'stop'
      attrcheck = { 'Container' => @options[:container] }
      @validate.attrvalidate(@options, attrcheck)
      manage
    else
      abort('you entered an invalid selection for Action')
    end
  end

  # this method is used to create update and delete orchestrations, it does not deal with running orchestations 
  # or start stop operations
  def update # rubocop:disable Metrics/AbcSize
    file = File.read(@options[:create_json]) unless @options[:action].downcase == 'delete'
    data_hash = JSON.parse(file) unless @options[:action].downcase == 'delete'
    @orch.create_json = data_hash unless @options[:action].downcase == 'delete'
    @orch.container = @options[:container] if @options[:action].downcase == 'delete'
    createcall = @orch.update(@options[:action])
    # error check for response
    @util.response_handler(createcall)
    return @options[:container] + ' deleted' if createcall.code == '204' && @options[:action].downcase == 'delete'
    return 'created ' + data_hash['name'] + JSON.pretty_generate(JSON.parse(createcall.body)) if createcall.code == '201' &&
                                                                                                 @options[:action].downcase == 'create'
    return 'updated ' + data_hash['name'] + JSON.pretty_generate(JSON.parse(createcall.body)) if createcall.code == '200' &&
                                                                                                 @options[:action].downcase == 'update'
  end

  # lists all orchestrations, list is a general list in a container, details will give you specifics on an orchestration
  def list # rubocop:disable Metrics/AbcSize
    result = @orch.list(@options[:action])
    @util.response_handler(result)
    JSON.pretty_generate(JSON.parse(result.body))
  end

  attr_writer :options, :orch, :util

  # handles the stopping and starting of orchestrations that are already defined in the cloud
  def manage # rubocop:disable Metrics/AbcSize
    orch_event = @orch.manage(@options[:action])
    @util.response_handler(orch_event)
    if @options[:track]
      puts 'starting' + @options[:container] if @options[:action] == 'start'
      puts 'stopping' + @options[:container] if @options[:action] == 'stop'
      statusresponse = JSON.parse(orch_event.body)
      if @options[:action] == 'start'
        until statusresponse['status'] == 'ready'
          sleep 35
          print '.'
          status_call = @orch.list('details')
          statusresponse = JSON.parse(status_call.body)
          abort('error, in orchestration it will not start') if statusresponse['status'] == 'error'
        end
      end
      if @options[:action] == 'stop'
        until statusresponse['status'] == 'stopped'
          sleep 25
          status_call = @orch.list('details')
          statusresponse = JSON.parse(status_call.body)
        end
      end
      JSON.pretty_generate(JSON.parse(status_call.body))
    else
      JSON.pretty_generate(JSON.parse(orch_event.body))
    end
  end
end 
