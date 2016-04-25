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
class OrchClient < OpcClient
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    @options = inputparse.compute('orch')
    attrcheck = { 'Action'        => @options[:action],
                  'REST endpoint' => @options[:rest_endpoint] }
    @validate = Validator.new
    @util = Utilities.new
    @validate.attrvalidate(@options, attrcheck)
    @orch = Orchestration.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
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

  def update # rubocop:disable Metrics/AbcSize
    file = File.read(@options[:create_json]) unless @options[:action].downcase == 'delete'
    data_hash = JSON.parse(file) unless @options[:action].downcase == 'delete'
    # createcall = @orch.update(@options[:action], data_hash) unless @options[:action].downcase == 'delete'
    @orch.create_json = data_hash unless @options[:action].downcase == 'delete'
    @orch.container = @options[:container] if @options[:action].downcase == 'delete'
    createcall = @orch.update(@options[:action])
    @util.response_handler(createcall)
    return @options[:container] + ' deleted' if createcall.code == '204' && @options[:action].downcase == 'delete'
    return 'created ' + data_hash['name'] + JSON.pretty_generate(JSON.parse(createcall.body)) if createcall.code == '201' &&
                                                                                                 @options[:action].downcase == 'create'
    return 'updated ' + data_hash['name'] + JSON.pretty_generate(JSON.parse(createcall.body)) if createcall.code == '200' &&
                                                                                                 @options[:action].downcase == 'update'
  end  # end create method

  def list # rubocop:disable Metrics/AbcSize
    result = @orch.list(@options[:container], @options[:action])
    @util.response_handler(result)
    JSON.pretty_generate(JSON.parse(result.body))
  end # end of method

  attr_writer :options, :orch, :util
  
  def manage # rubocop:disable Metrics/AbcSize
    orch_event = @orch.manage(@options[:action], @options[:container])
    @util.response_handler(orch_event)
    if @options[:track]
      statusresponse = JSON.parse(orch_event.body)
      # puts statusresponse['status']
      if @options[:action] == 'start'
        until statusresponse['status'] == 'ready'  do
          sleep 35
          print '.'
          status_call = @orch.list(@options[:container], 'details')
          statusresponse = JSON.parse(status_call.body)
          abort('error, in orchestration it will not start') if statusresponse['status'] == 'error'
        end
      end
      if @options[:action] == 'stop'
        until statusresponse['status'] == 'stopped'  do
          sleep 25
          status_call = @orch.list(@options[:container], 'details')
          statusresponse = JSON.parse(status_call.body)
        end
      end
      JSON.pretty_generate(JSON.parse(status_call.body))
    else
      JSON.pretty_generate(JSON.parse(orch_event.body))
    end # end of if
  end
end # end of class
