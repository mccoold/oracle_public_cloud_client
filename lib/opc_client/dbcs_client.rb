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
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class DbcsClient < OpcClient
  def dbaas_manage_client(args)
    inputparse =  InputParse.new(args)
    options = inputparse.jaas_manage
    attrcheck = {
      'Action'   => options[:action],
      'Instance' => options[:inst] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    abort(valid.at(1)) if valid.at(0) == 'true'
    instmanage = DbaasManager.new(options[:id_domain], options[:user_name], options[:passwd])
    options[:action].downcase
    case options[:action]
    when  'stop', 'start'
      result = instmanage.power(options[:inst], options[:action])
      if result.code == '401'
        puts 'authentication failed'
      elsif result.code == '404'
        puts 'instance not found'
      else
        result['Location']
      end
    when 'scaleup'
      file = File.read("#{options[:create_json]}")
      scaling = JSON.parse(file)
      result = instmanage.scale_up(scaling, options[:inst], options[:cluster_id])
      if result.code == '202'
        JSON.pretty_generate(JSON.parse(result.body))
      else
        result.body
      end # end of if
    end # end of case
  end  # end of method manage
end # end of class
