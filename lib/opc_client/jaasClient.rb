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
class JaasClient < OpcClient
  #
  require 'OPC/Jaas/instcreate'
  require 'OPC/Jaas/instdelete'
  require 'OPC/Jaas/srvlist'
  require 'OPC/Jaas/jaasManager'

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
      jcscreate = InstCreate.new
      createcall = jcscreate.create(data_hash, "#{options[:id_domain]}",
                                    "#{options[:user_name]}", "#{options[:passwd]}")
      if createcall.code == '401' or createcall.code == '404'
        puts 'Error with the REST Call'
        puts createcall.body
      else
        function = jcscreate
        util = Utilities.new
        util.create_result(options, createcall, function, 'jcs')
      end # end of main if
    end # end of validator if
  end  # end create method

  def srvice_list(args)
    inputparse =  InputParse.new(args)
    options = inputparse.inst_list
    attrcheck = nil
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      util = Utilities.new
      util.util_service_list(options, nil, SrvList)
    end # end of validator if
  end  # end of method list

  def delete(args)
    inputparse =  InputParse.new(args)
    options = inputparse.delete
    attrcheck = {
      'Instance' => options[:inst],
      'Delete_Config_JSON'   => options[:config] }
    deleteconfig = File.read("#{options[:config]}")
    data_hash = JSON.parse(deleteconfig)
    deleteinst = InstDelete.new
    JSON.pretty_generate(JSON.parse(deleteinst.delete(data_hash, "#{options[:id_domain]}", "#{options[:user_name]}",
                                                      "#{options[:passwd]}", "#{options[:inst]}")))
  end   # end of method

  def jaas_manage_client(args)
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
      instmanage = JaasManager.new
      options[:action].downcase
      case "#{options[:action]}"
      when  'stop', 'start'
        result = instmanage.mngstate("#{options[:timeout]}", "#{options[:inst]}", "#{options[:action]}",
                                     "#{options[:id_domain]}", "#{options[:user_name]}", "#{options[:passwd]}")
        result['location']
      when 'scaleup'
        result = instmanage.scale_up("#{options[:inst]}", "#{options[:cluster_id]}",
                                     "#{options[:id_domain]}","#{options[:user_name]}", "#{options[:passwd]}")
        if result.code == '202'
          result = JSON.parse(result.body)
          JSON.pretty_generate(result)
        else
          result.body
        end # end of if
      when 'scalein'
        puts "#{options[:serverid]}"
        result = instmanage.scale_in("#{options[:inst]}", "#{options[:serverid]}",
                                     "#{options[:id_domain]}", "#{options[:user_name]}", "#{options[:passwd]}")
        if result.code == '202'
          result = JSON.parse(result.body)
          JSON.pretty_generate(result)
        else
          result.body
        end # end of if
      when 'avail_patches'
        result = instmanage.available_patches("#{options[:inst]}", "#{options[:id_domain]}",
                                              "#{options[:user_name]}", "#{options[:passwd]}")
        if result.code == '200'
          result = JSON.parse(result.body)
          JSON.pretty_generate(result)
        else
          result.body
        end # end of if
      when 'applied_patches'
        result = instmanage.applied_patches("#{options[:inst]}", "#{options[:id_domain]}",
                                            "#{options[:user_name]}", "#{options[:passwd]}")
        if result.code == '200'
          result = JSON.parse(result.body)
          JSON.pretty_generate(result)
        else
          result.body
        end # end of if
      when 'patch_precheck'
        result = instmanage.patch_precheck("#{options[:inst]}", "#{options[:patch_id]}", "#{options[:id_domain]}",
                                            "#{options[:user_name]}", "#{options[:passwd]}")
        if result.code == '200'
          result = JSON.parse(result.body)
          JSON.pretty_generate(result)
        else
          result.body
        end # end of if
      when 'patch'
        result = instmanage.patch("#{options[:inst]}", "#{options[:patch_id]}", "#{options[:id_domain]}",
                                            "#{options[:user_name]}", "#{options[:passwd]}")
        if result.code == '200'
          result = JSON.parse(result.body)
          JSON.pretty_generate(result)
        else
          result.body
        end # end of if
      when 'patch_rollback'
        result = instmanage.patch_rollback("#{options[:inst]}", "#{options[:patch_id]}", "#{options[:id_domain]}",
                                            "#{options[:user_name]}", "#{options[:passwd]}")
        if result.code == '200'
          result = JSON.parse(result.body)
          JSON.pretty_generate(result)
        else
          result.body
        end # end of if
      else 
        puts 'Invalid selection for action option ' + "#{options[:action]}"    
      end # end of case
    end # end of validator
  end  # end of method manage
end   # end of class
