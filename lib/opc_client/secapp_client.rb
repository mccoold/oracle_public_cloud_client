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
# limitations under the License
#
class SecAppClient < OpcClient
  def secapp_discover(args)  # depricated needs to be deleted
    inputparse =  InputParse.new(args)
    options = inputparse.compute
    networkconfig = SecApp.new(options[:id_domain], options[:user_name], options[:passwd])
    networkconfig = networkconfig.discover(options[:rest_endpoint], options[:container])
    puts JSON.pretty_generate(JSON.parse(networkconfig.body))
  end # end of method

  def secapp_list(args)
    inputparse =  InputParse.new(args)
    options = inputparse.compute
    attrcheck = {
      'Action'    => options[:action],
      'Instance'  => options[:rest_endpoint],
      'Container' => options[:container] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    abort(valid.at(1)) if valid.at(0) == 'true'
    case options[:action].downcase
    when 'list'
      networkconfig = SecApp.new(options[:id_domain], options[:user_name], options[:passwd])
      networkconfig = networkconfig.discover(options[:rest_endpoint], options[:container])
      puts JSON.pretty_generate(JSON.parse(networkconfig.body))
    when 'details'
      networkconfig = SecApp.new(options[:id_domain], options[:user_name], options[:passwd])
      networkconfig = networkconfig.list(options[:rest_endpoint], options[:container])
      puts JSON.pretty_generate(JSON.parse(networkconfig.body))
    else
      puts 'invalid entry for action, please use details or list'
    end # end of case
  end # end of method

  def secapp_modify(args)
    inputparse =  InputParse.new(args)
    options = inputparse.compute
    attrcheck = {
      'Action'    => options[:action],
      'Instance'  => options[:rest_endpoint] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    abort(valid.at(1)) if valid.at(0) == 'true'
    networkconfig = SecApp.new(options[:id_domain], options[:user_name], options[:passwd])
    case options[:action].downcase
    when 'create'
      file = File.read(options[:create_json])
      update = JSON.parse(file)
      networkconfig = networkconfig.modify(options[:rest_endpoint], options[:action], update)
      puts JSON.pretty_generate(JSON.parse(networkconfig.body))
    when 'delete'
      networkconfig = networkconfig.modify(options[:rest_endpoint], options[:action], options[:container])
      puts 'deleted' if networkconfig.code == '204'
      puts 'error' + networkconfig.code  unless networkconfig.code == '204'
    else
      puts 'invalid entry for action, please use create or delete'
    end # end of case
  end # end of method
end # end of class
