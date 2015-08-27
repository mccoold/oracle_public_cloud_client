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
class DbaasClient < OpcClient
  #
  require 'OPC/Dbaas/dbservicelist'
  require 'OPC/Dbaas/dbcreate'
  require 'OPC/Dbaas/dbdelete'
  require 'OPC/Dbaas/dbaasManager'

  def dbservice_list(args)
    inputparse =  InputParse.new(args)
    options = inputparse.inst_list
    attrcheck = nil
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      util = Utilities.new
      util.util_service_list(options, 'db', DbServiceList)
    end # end of validator
  end  # end of method list

  def create(args)
    inputparse =  InputParse.new(args)
    options = inputparse.create
    attrcheck = {
      'create_json'   => options[:create_json] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      file = File.read("#{options[:create_json]}")
      data_hash = JSON.parse(file)
      dbcscreate = DbCreate.new
      createcall = dbcscreate.create(data_hash, "#{options[:id_domain]}",
                                     "#{options[:user_name]}", "#{options[:passwd]}")
      if createcall.code == '401' or createcall.code == '404'
        puts 'error'
        puts createcall.body
      else
        function = dbcscreate
        util = Utilities.new
        util.create_result(options, createcall, function, 'db')
      end # end of if
    end # end of validator
  end  # end create method

  def delete(args)
    inputparse =  InputParse.new(args)
    options = inputparse.delete
    attrcheck = {
      'Instance'   => options[:inst] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      deletedbaas = DbDelete.new
      JSON.pretty_generate(JSON.parse(deletedbaas.delete("#{options[:id_domain]}", "#{options[:user_name]}",
                                                         "#{options[:passwd]}", "#{options[:inst]}")))
    end # end of validator
  end   # end of method

  def dbaas_manage_client(args)
    inputparse =  InputParse.new(args)
    options = inputparse.jaas_manage
    attrcheck = {
      'Action'   => options[:action],
      'Instance' => options[:inst] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      instmanage = DbaasManager.new
      options[:action].downcase
      case "#{options[:action]}"
      when  'stop', 'start'
        result = instmanage.power("#{options[:inst]}", "#{options[:action]}", "#{options[:id_domain]}",
                                  "#{options[:user_name]}", "#{options[:passwd]}")
        if result.code == '401'
          puts 'authentication failed'
        elsif result.code == '404'
          puts 'instance not found'
        else
          result['Location']
        end
      when 'scaleup'
        result = instmanage.scale_up("#{options[:id_domain]}", "#{options[:inst]}", "#{options[:cluster_id]}",
                                     "#{options[:user_name]}", "#{options[:passwd]}")
        if result.code == '202'
          JSON.pretty_generate(JSON.parse(result.body))
        else
          result.body
        end # end of if
      end # end of case
    end # end of validator
  end  # end of method manage
end # end of class
