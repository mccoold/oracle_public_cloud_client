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
class SecListClient < OpcClient
  def list(args) # rubocop:disable Metrics/AbcSize
    if caller[0][/`([^']*)'/, 1] == '<top (required)>' || caller[0][/`([^']*)'/, 1].nil?
      inputparse =  InputParse.new(args)
      options = inputparse.compute('seclist')
      attrcheck = {
        'Action'    => options[:action],
        'Instance'  => options[:rest_endpoint],
        'Container' => options[:container] }
      @validate = Validator.new
      @validate.attrvalidate(options, attrcheck)
    end # end of if
    options = args unless caller[0][/`([^']*)'/, 1] == '<top (required)>' || caller[0][/`([^']*)'/, 1].nil?
    options[:action].downcase
    if options[:action] == 'list' || options[:action] == 'details'
      networkconfig = SecList.new(options[:id_domain], options[:user_name], options[:passwd])
      networkconfig = networkconfig.discover(options[:rest_endpoint], options[:container], options[:action])
      puts JSON.pretty_generate(JSON.parse(networkconfig.body))
    else
      puts 'Invalid entry for action, please use details or list'
    end # end of if
  end # end of method

  def update(args) # rubocop:disable Metrics/AbcSize
    if caller[0][/`([^']*)'/, 1] == '<top (required)>' || caller[0][/`([^']*)'/, 1].nil?
      inputparse =  InputParse.new(args)
      options = inputparse.compute('seclist')
      attrcheck = {
        'Instance'  => options[:rest_endpoint],
        'Container' => options[:container] }
      @validate = Validator.new
      @validate.attrvalidate(options, attrcheck)
      
    end
    options = args unless caller[0][/`([^']*)'/, 1] == '<top (required)>' || caller[0][/`([^']*)'/, 1].nil?
    networkconfig = SecList.new(options[:id_domain], options[:user_name], options[:passwd])
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
