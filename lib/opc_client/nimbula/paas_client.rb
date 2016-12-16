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
class PaasClient < NimbulaClient
  
  require 'opc_client/nimbula/helpers'
  include NimbulaHelpers::NimCommandLine
  
  def intialize
    @validate = Validator.new
  end
    
  def optparse
    @util = Utilities.new
    case @options[:action]
    when 'create'
      case @options[:function]
      when 'dbcs', 'soa', 'jcs'
        create
      when 'acc'
        create_acc
      end
    when 'delete'
      case @options[:function]
      when 'dbcs', 'soa', 'jcs'
        delete
      when 'acc'
      end
    when 'list', 'details'
      service_list
    end
  end
    
  attr_writer :action, :validate, :util, :options, :argsfunction
  
  # create method for JCS, SOA, DBCS  
  def create # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'create_json'   => @options[:create_json] }
    @validate.attrvalidate(@options, attrcheck)
    file = File.read(@options[:create_json])
    create_data = JSON.parse(file)
    resultparse = PaasHelpers.new
    opccreate = InstCreate.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:function])
    @options[:paas_rest_endpoint] = resultparse.paas_url(@options[:paas_rest_endpoint], @options[:function]) if @options[:paas_rest_endpoint]
    opccreate.url = @options[:paas_rest_endpoint] if @options[:paas_rest_endpoint]
    createcall = opccreate.create(create_data)
    @util.response_handler(createcall)
    resultparse = PaasHelpers.new
    resultparse.create_result(@options, createcall, opccreate)
  end

  # delete method for SOA, DBCS, JCS
  def delete # rubocop:disable Metrics/AbcSize
    attrcheck = { 'Instance' => @options[:inst] }
    @validate.attrvalidate(@options, attrcheck)
    helper = PaasHelpers.new if @options[:paas_rest_endpoint]
    deleteconfig = File.read(@options[:config]) if @options[:function] == 'jcs'
    data_hash = JSON.parse(deleteconfig) if @options[:function] == 'jcs'
    deleteinst = InstDelete.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:function])
    @options[:paas_rest_endpoint] = helper.paas_url(@options[:paas_rest_endpoint], @options[:function]) if @options[:paas_rest_endpoint]
    deleteinst.url = @options[:paas_rest_endpoint] if @options[:paas_rest_endpoint]
    result = deleteinst.delete(data_hash, @options[:inst]) if @options[:function] == 'jcs'
    result = deleteinst.delete(nil, @options[:inst]) if @options[:function] == 'dbcs'
    @util.response_handler(result)
    JSON.pretty_generate(JSON.parse(result.body))
  end
  
  # creates new application container cloud instance
  def acc_create # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'application_file'   => @options[:application] }
    @validate.attrvalidate(@options, attrcheck)
    contain = Container.new(@options[:id_domain], @options[:user_name], @options[:passwd])
    file = File.read(@options[:deployment]) if @options[:deployment]
    create_data = JSON.parse(file)
    contain.applicationfile = @options[:application] if @options[:application]
    createcall = opccreate.create(create_data)
  end
  
  # general list function for paas containers
  def service_list # rubocop:disable Metrics/AbcSize
      list_result = SrvList.new(@options)
      helper = PaasHelpers.new if @options[:paas_rest_endpoint]
      @options[:paas_rest_endpoint] = helper.paas_url(@options) if @options[:paas_rest_endpoint]
      list_result.url = @options[:paas_rest_endpoint] if @options[:paas_rest_endpoint]
      if @options[:inst]
        inst_list(list_result)
      else
        result = list_result.service_list
        @util.response_handler(result)
        JSON.pretty_generate(JSON.parse(result.body))
      end
    end
  
    # list functionality for getting details on  PaaS instances of various types JCS, SOA, DBCS
    def inst_list(result) # rubocop:disable Metrics/AbcSize
      if @options[:mang] == 'true'
        result.server_name = @options[:serverid] if @options[:serverid]
        result = result.managed_list(@options[:inst])
        puts JSON.pretty_generate(JSON.parse(result.body)) if result.code == '200'
        puts 'error in requrest' + result.code unless result.code == '200'
      else
        result = result.inst_list(@options[:inst])
        case @options[:function].downcase
        when 'jcs', 'soa'
          @util.response_handler(result)
          return JSON.pretty_generate(JSON.parse(result.body))
        when 'dbcs'
          @util.response_handler(result)
          result_json = JSON.parse(result.body)
          return JSON.pretty_generate(result_json)
        else
          print 'what are you sending? It is not correct'
        end
      end
    end
end
