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
class BlockStorageClient < OpcClient
  #
  # require 'OPC/Iaas/blockstorage'
  def list(args)
    inputparse =  InputParse.new(args)
    options = inputparse.compute
    attrcheck = {
      'Action'    => options[:action],
      'Instance'  => options[:rest_endpoint],
      'Container' => options[:container] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      options[:action].downcase
      if options[:action] == 'list' || options[:action] == 'details'
        storageconfig = BlockStorage.new(options[:id_domain], options[:user_name], options[:passwd])
        storageconfig = storageconfig.list(options[:rest_endpoint], options[:container], options[:action])
        puts JSON.pretty_generate(JSON.parse(storageconfig.body))
      else
        puts 'invalid entry for action, please use details or list'
      end # end of if
    end # end of validator
  end # end of method

  def update(args)
    inputparse =  InputParse.new(args)
    options = inputparse.compute
    attrcheck = {
      'Instance'  => options[:rest_endpoint],
      'Container' => options[:container] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      storageconfig = BlockStorage.new(options[:id_domain], options[:user_name], options[:passwd])
      case options[:action]
      when 'create'
        file = File.read(options[:create_json])
        update = JSON.parse(file)
        storageupdate = storageconfig.update(options[:rest_endpoint], options[:action], update)
        JSON.pretty_generate(JSON.parse(storageupdate.body))
      when 'delete'
        storageupdate = storageconfig.secrule_update(options[:rest_endpoint], options[:container],
                                                     options[:action])
        JSON.pretty_generate(JSON.parse(storageupdate.body))
      else
        puts 'invalid entry'
      end # end of case
    end # end of validator
  end # end of method
end
