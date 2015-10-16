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
  require 'opc/paas/jcs/backupmanager'

  def jcsbackup_list(args)
    inputparse =  InputParse.new(args)
    options = inputparse.inst_list
    attrcheck = nil
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      result = BackUpManager.new
      if options[:backup_id].nil?
        result = result.backup_list(options[:inst], nil, options[:id_domain],
                                    options[:user_name], options[:passwd])
      else
        result = result.backup_list(options[:inst], options[:backup_id], options[:id_domain],
                                    options[:user_name], options[:passwd])
      end
      if result.code == '401' || result.code == '400' || result.code == '404'
        puts 'error, JSON was not returned  the http response code was' + result.code
      else
        JSON.pretty_generate(JSON.parse(result.body))
      end # end of if
    end # end of validator
  end # end of method

  def jcsbackup_config_list(args)
    inputparse =  InputParse.new(args)
    options = inputparse.inst_list
    attrcheck = nil
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      result = BackUpManager.new
      result = result.backup_config_list(options[:inst], options[:id_domain],
                                         options[:user_name], options[:passwd])
      if result.code == '401' || result.code == '400' || result.code == '404'
        puts 'error, JSON was not returned  the http response code was'
        puts result.code
      else
        JSON.pretty_generate(JSON.parse(result.body))
      end # end of if
    end # end of validator
  end # end of method
end
