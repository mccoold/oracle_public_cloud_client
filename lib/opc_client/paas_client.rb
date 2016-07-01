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
class PaasClient < OpcClient
  
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    @options = inputparse.create if @action == 'create'
    @options = inputparse.delete if @action == 'delete'
    attrcheck = { 'Service'  => @options[:function] }
    @validate = Validator.new
    @validate.attrvalidate(@options, attrcheck)
    @util = Utilities.new
    case @action
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
    end
  end
    
  attr_writer :action, :validate, :util, :options
    
  def create # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'create_json'   => @options[:create_json] }
    @validate.attrvalidate(@options, attrcheck)
    file = File.read(@options[:create_json])
    create_data = JSON.parse(file)
    opccreate = InstCreate.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:function])
    opccreate.url = @options[:rest_endpoint] if @options[:rest_endpoint]
    createcall = opccreate.create(create_data)
    @util.response_handler(createcall)
    @util.create_result(@options, createcall, opccreate)
  end  # end create method

  def delete # rubocop:disable Metrics/AbcSize
    attrcheck = { 'Instance' => @options[:inst] }
    @validate.attrvalidate(@options, attrcheck)
    deleteconfig = File.read(@options[:config]) if @options[:function] == 'jcs'
    data_hash = JSON.parse(deleteconfig) if @options[:function] == 'jcs'
    deleteinst = InstDelete.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:function])
    deleteinst.url = @options[:rest_endpoint] if @options[:rest_endpoint]
    result = deleteinst.delete(data_hash, @options[:inst]) if @options[:function] == 'jcs'
    result = deleteinst.delete(nil, @options[:inst]) if @options[:function] == 'dbcs'
    @util.response_handler(result)
    JSON.pretty_generate(JSON.parse(result.body)) if result.code == '202'
  end # end of method
  
  def acc_create # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'application_file'   => @options[:application] }
    @validate.attrvalidate(@options, attrcheck)
    contain = Container.new(@options[:id_domain], @options[:user_name], @options[:passwd])
    file = File.read(@options[:deployment]) if @options[:deployment]
    create_data = JSON.parse(file)
    contain.applicationfile = @options[:application] if @options[:application]
    createcall = opccreate.create(create_data)
  end  # end acc create method
end # end of class
