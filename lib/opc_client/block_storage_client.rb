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
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    options = inputparse.compute('blockstorage')
    attrcheck = {
      'Action'         => options[:action],
      'REST endpoint'  => options[:rest_endpoint],
      'Container'      => options[:container]
    }
    @validate = Validator.new
    @validate.attrvalidate(options, attrcheck)
    case options[:action].downcase
    when 'create'
      update(options)
    when 'list'
      list(options)
    when 'delete'
      update(options)
    else
      abort('you entered an invalid selection for Action')
    end # end case
  end # end method

  def list(options)  # rubocop:disable Metrics/AbcSize
    options[:action].downcase
    if options[:action] == 'list' || options[:action] == 'details'
      storageconfig = BlockStorage.new(options[:id_domain], options[:user_name], options[:passwd])
      storageconfig = storageconfig.list(options[:rest_endpoint], options[:container], options[:action])
      puts JSON.pretty_generate(JSON.parse(storageconfig.body))
    else
      puts 'invalid entry for action, please use details or list'
    end # end of if
  end # end of method

  def update(options) # rubocop:disable Metrics/AbcSize
    storageconfig = BlockStorage.new(options[:id_domain], options[:user_name], options[:passwd])
    case options[:action].downcase
    when 'create'
      attrcheck = { 'create_json' => options[:create_json] }
      @validate.attrvalidate(options, attrcheck)
      file = File.read(options[:create_json])
      update = JSON.parse(file)
      storageupdate = storageconfig.update(options[:rest_endpoint], options[:action], update)
      JSON.pretty_generate(JSON.parse(storageupdate.body))
    when 'delete'
      storageupdate = storageconfig.secrule_update(options[:rest_endpoint], options[:container],
                                                   options[:action])
      JSON.pretty_generate(JSON.parse(storageupdate.body))
    else
      abort('invalid entry')
    end # end of case
  end # end of method
end
