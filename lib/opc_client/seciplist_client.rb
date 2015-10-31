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
class SecIPListClient < OpcClient
  def list(args)
    if caller[0][/`([^']*)'/, 1] == '<top (required)>' || caller[0][/`([^']*)'/, 1].nil?
      # if the method is called directly from command line
      inputparse =  InputParse.new(args)
      options = inputparse.compute('seciplist')
      attrcheck = {
        'Action'    => options[:action],
        'Instance'  => options[:rest_endpoint],
        'Container' => options[:container] }
      validate = Validator.new
      valid = validate.attrvalidate(options, attrcheck)
      abort(valid.at(1)) if valid.at(0) == 'true'
    end # end of if
    options = args unless caller[0][/`([^']*)'/, 1] == '<top (required)>' || caller[0][/`([^']*)'/, 1].nil?
    # allows method to be called by other methods
    options[:action].downcase
    if options[:action] == 'list' || options[:action] == 'details'
      networkconfig = SecIPList.new(options[:id_domain], options[:user_name], options[:passwd])
      networkconfig = networkconfig.discover(options[:rest_endpoint], options[:container], options[:action])
      puts JSON.pretty_generate(JSON.parse(networkconfig.body))
    else
      puts 'invalid entry for action, please use details or list'
    end # end of if
  end # end of method

  def update(args)
    if caller[0][/`([^']*)'/, 1] == '<top (required)>' || caller[0][/`([^']*)'/, 1].nil?
       # if the method is called directly from command line the reason for the or is ruby 1.8 support
      inputparse =  InputParse.new(args)
      options = inputparse.compute('seciplist')
      attrcheck = {
        'Instance'  => options[:rest_endpoint],
        'Container' => options[:container] }
      validate = Validator.new
      valid = validate.attrvalidate(options, attrcheck)
      abort(valid.at(1)) if valid.at(0) == 'true'
      networkconfig = SecIPList.new(options[:id_domain], options[:user_name], options[:passwd])
    end
    options = args unless caller[0][/`([^']*)'/, 1] == '<top (required)>' || caller[0][/`([^']*)'/, 1].nil?
    case options[:action]
    when 'update'
      key_sep = '='
      updates = Hash.new
      options[:list].each do |v|
        key_value = v.split(key_sep)
        updates[key_value.at(0)] = key_value.at(1)
      end # end of parsing through the update parameters
      networklist = networkconfig.list(options[:rest_endpoint], options[:container], options[:action])
      data = JSON.parse(networklist.body).first
      data1 = data.at(1)
      update = data1.at(0)
      updates.each do |k, v|
        update[k] = v
      end
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action], update)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    when 'create'
      file = File.read(options[:create_json])
      update = JSON.parse(file)
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action], update)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    when 'delete'
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action])
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    else
      puts 'invalid entry for action'
    end # end of case
  end # end of method
end
