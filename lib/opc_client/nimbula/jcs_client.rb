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
class JcsClient < NimbulaClient
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse = InputParse.new(args)
    @options = inputparse.manage
    attrcheck = { 'Action' => @options[:action] }
    @validate = Validator.new
    @util = Utilities.new
    @validate.attrvalidate(@options, attrcheck)
    @url = 'https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/' if @options[:function] == 'jcs' || @options[:function].nil?
    @url = 'https://jaas.oraclecloud.com/paas/service/soa/api/v1.1/instances/' if @options[:function] == 'soa'
    jaas_manage_client unless @options[:function] == 'backup'
    if @options[:function] == 'backup'
      backup = BackUpClient.new
      backup.options = @options
      backup.option_parse
    end
  end

  attr_writer :url

  def jaas_manage_client # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'Instance' => @options[:inst],
      'Service'  => @options[:function]
    }
    @validate.attrvalidate(@options, attrcheck)
    instmanage = JaasManager.new(@options[:id_domain], @options[:user_name], @options[:passwd])
    instmanage.url = @url
    instmanage.timeout = @options[:timeout] if @options[:timeout]
    case @options[:action].downcase
    when 'stop', 'start'
      result = instmanage.mngstate(@options[:inst], @options[:action])
      @util.response_handler(result)
      puts result['location']
      opccreate = InstCreate.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:function])
      @util.create_result(@options, result, opccreate)
    when 'scaleup'
      if @options[:mang] == 'false'
        attrcheck = { 'create_json' => @options[:create_json] }
        @validate.attrvalidate(@options, attrcheck)
        file = File.read(@options[:create_json])
        scale_data = JSON.parse(file)
        instmanage.update_json = scale_data
      end
      attrcheck = {
        'cluster name' => @options[:cluster_id],
        'Inst ID'      => @options[:inst]
      }
      @validate.attrvalidate(@options, attrcheck)
      result = instmanage.scale_up(@options[:inst], @options[:cluster_id])
      @util.response_handler(result)
      puts JSON.pretty_generate(JSON.parse(result.body))
    when 'scalein'
      result = instmanage.scale_in(@options[:inst], @options[:serverid])
      @util.response_handler(result)
      puts JSON.pretty_generate(JSON.parse(result.body))
    when 'avail_patches'
      result = instmanage.available_patches(@options[:inst])
      @util.response_handler(result)
      return JSON.pretty_generate(JSON.parse(result.body))
    when 'applied_patches'
      result = instmanage.applied_patches(@options[:inst])
      @util.response_handler(result)
      return JSON.pretty_generate(JSON.parse(result.body))
    when 'patch_precheck'
      result = instmanage.patch_precheck(@options[:inst], @options[:patch_id])
      @util.response_handler(result)
      return JSON.pretty_generate(JSON.parse(result.body))
    when 'patch'
      result = instmanage.patch(@options[:inst], @options[:patch_id])
      @util.response_handler(result)
      return JSON.pretty_generate(JSON.parse(result.body))
    when 'patch_rollback'
      result = instmanage.patch_rollback(@options[:inst], @options[:patch_id])
      @util.response_handler(result)
      puts JSON.pretty_generate(JSON.parse(result.body))
    else
      puts 'Invalid selection for action Option ' + @options[:action]
    end
  end
end
