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
class JcsClient < OpcClient
  def jaas_manage_client(args)
    inputparse =  InputParse.new(args)
    options = inputparse.jaas_manage
    attrcheck = {
      'Action'   => options[:action],
      'Instance' => options[:inst] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    abort(valid.at(1)) if valid.at(0) == 'true'
    instmanage = JaasManager.new(options[:id_domain], options[:user_name], options[:passwd])
    case options[:action].downcase
    when  'stop', 'start'
      attrcheck = { 'Timeout' => options[:timeout] }
      valid = validate.attrvalidate(options, attrcheck)
      abort(valid.at(1)) if valid.at(0) == 'true'
      result = instmanage.mngstate(options[:timeout], options[:inst], options[:action])
      result['location']
    when 'scaleup'
      result = instmanage.scale_up(options[:inst], options[:cluster_id])
      puts JSON.pretty_generate(JSON.parse(result.body)) if result.code == '202'
      puts result.body unless result.code == '202'
    when 'scalein'
      result = instmanage.scale_in(options[:inst], options[:serverid])
      puts JSON.pretty_generate(JSON.parse(result.body)) if result.code == '202'
      puts result.body unless result.code == '202'
    when 'avail_patches'
      result = instmanage.available_patches(options[:inst])
      puts JSON.pretty_generate(JSON.parse(result.body)) if result.code == '200'
      puts 'error' + result.code unless result.code == '200'
    when 'applied_patches'
      result = instmanage.applied_patches(options[:inst])
      puts JSON.pretty_generate(JSON.parse(result.body)) if result.code == '200'
      puts 'error' + result.code unless result.code == '200'
    when 'patch_precheck'
      result = instmanage.patch_precheck(options[:inst], options[:patch_id])
      puts JSON.pretty_generate(JSON.parse(result.body)) if result.code == '200'
      puts 'error' + result.code unless result.code == '200'
    when 'patch'
      result = instmanage.patch(options[:inst], options[:patch_id])
      puts JSON.pretty_generate(JSON.parse(result.body)) if result.code == '200'
      puts result.body unless result.code == '200'
    when 'patch_rollback'
      result = instmanage.patch_rollback(options[:inst], options[:patch_id])
      puts JSON.pretty_generate(JSON.parse(result.body)) if result.code == '200'
      puts 'error' + result.code unless result.code == '200'
    else
      puts 'Invalid selection for action option ' + options[:action]
    end # end of case
  end  # end of method manage
end   # end of class
