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
    options = inputparse.compute('orch')
    attrcheck = { 'Action'        => options[:action],
                  'REST endpoint' => options[:rest_endpoint] }
    @validate = Validator.new
    @validate.attrvalidate(options, attrcheck)
    case options[:action]
    when 'create', 'update', 'delete'
      attrcheck = { 'create_json' => options[:create_json] } unless options[:action].downcase == 'delete'
      attrcheck = { 'orch Instance -I' => options[:inst] } if options[:action].downcase == 'delete'
      @validate.attrvalidate(options, attrcheck)
      update(options)
    when 'list', 'details'
      attrcheck = { 'Container' => options[:container] }
      @validate.attrvalidate(options, attrcheck)
      list(options)
    when 'start', 'stop'
      attrcheck = { 'orch Instance -I' => options[:inst] }
      @validate.attrvalidate(options, attrcheck)
    else
      abort('you entered an invalid selection for Action')
    end
  end

  def update(options) # rubocop:disable Metrics/AbcSize
    file = File.read(options[:create_json]) unless options[:action].downcase == 'delete'
    data_hash = JSON.parse(file) unless options[:action].downcase == 'delete'
    orch = Orchestration.new(options[:id_domain], options[:user_name], options[:passwd])
    createcall = orch.update(options[:rest_endpoint], options[:action],
                             data_hash) unless options[:action].downcase == 'delete'
    createcall = orch.update(options[:rest_endpoint],
                             options[:action], options[:inst]) if options[:action].downcase == 'delete'
    'error' + createcall.body if createcall.code == '400'
    options[:inst] + 'deleted' if createcall.code == '204' && options[:action].downcase == 'delete'
    'created ' + data_hash['name'] + JSON.pretty_generate(JSON.parse(createcall.body)) if createcall.code == '201' &&
                                                                                          options[:action].downcase == 'create'
    'updated ' + data_hash['name'] + JSON.pretty_generate(JSON.parse(createcall.body)) if createcall.code == '200' &&
                                                                                          options[:action].downcase == 'update'
  end  # end create method

  def list(options) # rubocop:disable Metrics/AbcSize
    result = Orchestration.new(options[:id_domain], options[:user_name], options[:passwd])
    result = result.list(options[:rest_endpoint], options[:container], options[:action])
    if result.code == '401' || result.code == '400' || result.code == '404'
      puts 'error, JSON was not returned  the http response code was' + result.code
    else
      JSON.pretty_generate(JSON.parse(result.body))
    end # end of if
  end # end of method

  def manage(options) # rubocop:disable Metrics/AbcSize
    orch = Orchestration.new(options[:id_domain], options[:user_name], options[:passwd])
    orch_event = orch.manage(options[:rest_endpoint], options[:action], options[:container])
    if orch_event.code == '401' || orch_event.code == '400' || orch_event.code == '404'
      puts 'error, JSON was not returned  the http response code was' + orch_event.code
    else
      JSON.pretty_generate(JSON.parse(orch_event.body))
    end # end of if
  end
end # end of class
