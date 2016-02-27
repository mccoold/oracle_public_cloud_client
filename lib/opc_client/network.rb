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
class Network < OpcClient
  def input(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    options = inputparse.compute('network')
    attrcheck = nil
    @validate = Validator.new
    @validate.attrvalidate(options, attrcheck)
    file = File.read(options[:create_json])
    inputdata = JSON.parse(file)
    inputdata.each do |json_top_level|
      network_category = json_top_level.at(0).downcase
      json_top_level.at(1).each do |category_instance|
        if network_category == 'secapp'
          networkconfig = SecApp.new(options[:id_domain], options[:user_name], options[:passwd])
          case category_instance.at(1)['Action'].downcase
          when 'create'
            puts 'created'
            networkconfig = networkconfig.modify(options[:rest_endpoint], 'create', category_instance.at(1)['Parameters'])
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'delete'
            networkconfig = networkconfig.modify(options[:rest_endpoint],  'delete',
                                                 category_instance.at(1)['Parameters']['name'])
            puts 'deleted secapplication ' + category_instance.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end
        elsif network_category == 'secrule'
          networkconfig = SecRule.new(options[:id_domain], options[:user_name], options[:passwd])
          case category_instance.at(1)['Action']
          when 'create'
            networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', category_instance.at(1)['Parameters'])
            puts 'created'
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'modify'
            networkconfig = networkconfig.update(options[:rest_endpoint], category_instance.at(1)['Parameters']['name'], 'update',
                                                 category_instance.at(1)['Parameters'])
            puts 'updated rule ' + category_instance.at(1)['Parameters']['name'] if networkconfig.code == '204'
          when 'delete'
            networkconfig = networkconfig.update(options[:rest_endpoint], category_instance.at(1)['Parameters']['name'], 'delete',
                                                 category_instance.at(1)['Parameters'])
            puts 'deleted rule ' + category_instance.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end
        elsif network_category == 'seclist'
          networkconfig = SecList.new(options[:id_domain], options[:user_name], options[:passwd])
          case category_instance.at(1)['Action']
          when 'create'
            puts 'created'
            networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', category_instance.at(1)['Parameters'])
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'update'
            puts 'updated'
            networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'update', category_instance.at(1)['Parameters'])
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'delete'
            networkconfig = networkconfig.update(options[:rest_endpoint], category_instance.at(1)['Parameters']['name'], 'delete',
                                                 json_top_level.at(1)['Parameters'])
            puts 'deleted Sec List ' + category_instance.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end
        elsif network_category == 'seciplist'
          networkconfig = SecIPList.new(options[:id_domain], options[:user_name], options[:passwd])
          case category_instance.at(1)['Action']
          when 'create'
            puts 'created'
            networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', category_instance.at(1)['Parameters'])
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'update'
            puts 'updated'
            networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'update', category_instance.at(1)['Parameters'])
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'delete'
            networkconfig = networkconfig.update(options[:rest_endpoint], category_instance.at(1)['Parameters']['name'], 'delete',
                                                 category_instance.at(1)['Parameters'])
            puts 'deleted SecIP List ' + category_instance.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end
        elsif network_category == 'secassoc'
          networkconfig = SecAssoc.new(options[:id_domain], options[:user_name], options[:passwd])
          case category_instance.at(1)['Action']
          when 'create'
            puts 'created'
            networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', category_instance.at(1)['Parameters'])
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'modify'
            puts 'not available on OPC yet'
          when 'delete'
            networkconfig = networkconfig.update(options[:rest_endpoint], category_instance.at(1)['Parameters']['name'], 'delete',
                                                 category_instance.at(1)['Parameters'])
            puts 'deleted Secassoc ' + json_top_level.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end
        elsif network_category == 'ip'
          networkconfig = IPUtil.new(options[:id_domain], options[:user_name], options[:passwd], options[:rest_endpoint])
          callclass = category_instance.at(1)['Class']
          case category_instance.at(1)['Action']
          when 'create'
            networkconfig.create_json =  category_instance.at(1)['Parameters']
            networkconfig = networkconfig.update('create', callclass)
            puts 'created'
            return JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'modify'
            puts 'not fully available yet'
          when 'delete'
            networkconfig.ipcontainer_name = category_instance.at(1)['Parameters']['name']
            networkconfig = networkconfig.update('delete',
                                                 callclass, category_instance.at(1)['Parameters'])
            return 'deleted IP ' + callclass + ' ' + category_instance.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end # end of case
        end # end of if
      end # end of json_top_level loop
    end # end of loop for inputdata
  end  # end create method
end # end of class
