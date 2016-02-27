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
class BackUpClient < OpcClient
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    options = inputparse.create
    attrcheck = { 'Action'    => options[:action] }
    @validate = Validator.new
    @validate.attrvalidate(options, attrcheck)
    @url = 'https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/' if @options[:function] == 'jcs' || @options[:function].nil?
    @url = 'https://jaas.oraclecloud.com/paas/service/soa/api/v1.1/instances/' if @options[:function] == 'soa'
    case options[:action].downcase
    when 'config_list'
      config_list(options)
    when 'list'
      list(options)
    when 'delete'
      delete(options)
    when 'config'
      config(options)
    when 'initiate'
      initiate(options)
    else
      abort('you entered an invalid selection for Action')
    end # end case
  end # end method

  attr_writer :url

  def list(options) # rubocop:disable Metrics/AbcSize
    result = BackUpManager.new(options[:id_domain], options[:user_name], options[:passwd])
    result.url = @url
    attrcheck = { 'Instance'  => options[:inst] }
    @validate.attrvalidate(options, attrcheck)
    if options[:backup_id].nil?
      result = result.list(options[:inst], nil)
    else
      result = result.list(options[:inst], options[:backup_id])
    end
    if result.code == '401' || result.code == '400' || result.code == '404'
      puts 'error, JSON was not returned  the http response code was' + result.code
    else
      JSON.pretty_generate(JSON.parse(result.body))
    end # end of if
  end # end of method

  def config_list(options) # rubocop:disable Metrics/AbcSize
    attrcheck = { 'Instance'    => options[:inst] }
    @validate.attrvalidate(options, attrcheck)
    result = BackUpManager.new(options[:id_domain], options[:user_name], options[:passwd])
    result = result.config_list(options[:inst])
    if result.code == '401' || result.code == '400' || result.code == '404'
      puts 'error, JSON was not returned  the http response code was'
      puts result.code
    else
      JSON.pretty_generate(JSON.parse(result.body))
    end # end of if
  end # end of method

  def config(options) # rubocop:disable Metrics/AbcSize
    attrcheck = { 'Instance'    => options[:inst],
                  'create_json' => options[:create_json] }
    @validate.attrvalidate(options, attrcheck)
    file = File.read(options[:create_json])
    data_hash = JSON.parse(file)
    result = BackUpManager.new(options[:id_domain], options[:user_name], options[:passwd])
    result = result.config(data_hash, options[:inst])
    if result.code == '401' || result.code == '400' || result.code == '404'
      puts 'error, JSON was not returned  the http response code was' + result.code
    else
      JSON.pretty_generate(JSON.parse(result.body))
    end # end of if
  end # end of method

  def initiate(options) # rubocop:disable Metrics/AbcSize
    file = File.read(options[:create_json])
    bkup_json_hash = JSON.parse(file)
    result = BackUpManager.new(options[:id_domain], options[:user_name], options[:passwd])
    result = result.initialize_backup(bkup_json_hash, options[:inst])
    if result.code == '401' || result.code == '400' || result.code == '404'
      puts 'error, JSON was not returned  the http response code was' + result.code
    else
      JSON.pretty_generate(JSON.parse(result.body))
    end # end of if
  end # end of method

  def delete(options) # rubocop:disable Metrics/AbcSize
    attrcheck = { 'Instance'  => options[:inst],
                  'Backup'    => options[:backup_id]  }
    @validate.attrvalidate(options, attrcheck)
    result = BackUpManager.new(options[:id_domain], options[:user_name], options[:passwd])
    result = result.delete(options[:inst], options[:backup_id])
    if result.code == '401' || result.code == '400' || result.code == '404'
      puts 'error, JSON was not returned  the http response code was' + result.code
    else
      JSON.pretty_generate(JSON.parse(result.body))
    end # end of if
  end # end of method
end
