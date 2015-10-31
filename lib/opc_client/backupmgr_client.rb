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
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    abort(valid.at(1)) if valid.at(0) == 'true'
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

  def list(options) # rubocop:disable Metrics/AbcSize
    result = BackUpManager.new(options[:id_domain], options[:user_name], options[:passwd])
    attrcheck = { 'Instance'    => options[:inst] }
    valid = validate.attrvalidate(options, attrcheck)
    abort(valid.at(1)) if valid.at(0) == 'true'
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
    valid = validate.attrvalidate(options, attrcheck)
    abort(valid.at(1)) if valid.at(0) == 'true'
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
    valid = validate.attrvalidate(options, attrcheck)
    abort(valid.at(1)) if valid.at(0) == 'true'
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
    data_hash = JSON.parse(file)
    result = BackUpManager.new(options[:id_domain], options[:user_name], options[:passwd])
    result = result.initialize_backup(data_hash, options[:inst])
    if result.code == '401' || result.code == '400' || result.code == '404'
      puts 'error, JSON was not returned  the http response code was' + result.code
    else
      JSON.pretty_generate(JSON.parse(result.body))
    end # end of if
  end # end of method

  def delete(options) # rubocop:disable Metrics/AbcSize
    attrcheck = { 'Instance'  => options[:inst],
                  'Backup'    => options[:backup_id]  }
    valid = validate.attrvalidate(options, attrcheck)
    abort(valid.at(1)) if valid.at(0) == 'true'
    result = BackUpManager.new(options[:id_domain], options[:user_name], options[:passwd])
    result = result.delete(options[:inst], options[:backup_id])
    if result.code == '401' || result.code == '400' || result.code == '404'
      puts 'error, JSON was not returned  the http response code was' + result.code
    else
      JSON.pretty_generate(JSON.parse(result.body))
    end # end of if
  end # end of method
end
