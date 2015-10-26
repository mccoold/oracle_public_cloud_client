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
  def input(args)
    inputparse =  InputParse.new(args)
    options = inputparse.compute
    attrcheck = nil
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    abort(valid.at(1)) if valid.at(0) == 'true'
    file = File.read(options[:create_json])
    inputdata = JSON.parse(file)
    inputdata.each do |app|
      func = app.at(0).downcase
      app.at(1).each do |conf|
        if func == 'secapp'
          networkconfig = SecApp.new(options[:id_domain], options[:user_name], options[:passwd])
          case conf.at(1)['Action']
          when 'create'
            puts 'created'
            networkconfig = networkconfig.modify(options[:rest_endpoint], 'create', conf.at(1)['Parameters'])
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'delete'
            networkconfig = networkconfig.modify(options[:rest_endpoint],  'delete',
                                                 conf.at(1)['Parameters']['name'])
            puts 'deleted secapplication ' + conf.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end
        elsif func == 'secrule'
          networkconfig = SecRule.new(options[:id_domain], options[:user_name], options[:passwd])
          case conf.at(1)['Action']
          when 'create'
            networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', conf.at(1)['Parameters'])
            puts 'created'
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'modify'
            puts 'nothing done yet'
          when 'delete'
            networkconfig = networkconfig.update(options[:rest_endpoint], conf.at(1)['Parameters']['name'], 'delete',
                                                 conf.at(1)['Parameters'])
            puts 'deleted rule ' + conf.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end
        elsif func == 'seclist'
          networkconfig = SecList.new(options[:id_domain], options[:user_name], options[:passwd])
          case conf.at(1)['Action']
          when 'create'
            puts 'created'
            networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', conf.at(1)['Parameters'])
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'modify'
            puts 'nothing done yet'
          when 'delete'
            networkconfig = networkconfig.update(options[:rest_endpoint], conf.at(1)['Parameters']['name'], 'delete',
                                                 app.at(1)['Parameters'])
            puts 'deleted Sec List ' + conf.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end
        elsif func == 'seciplist'
          networkconfig = SecIPList.new(options[:id_domain], options[:user_name], options[:passwd])
          case conf.at(1)['Action']
          when 'create'
            networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', conf.at(1)['Parameters'])
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'modify'
            puts 'nothing done yet'
          when 'delete'
            networkconfig = networkconfig.update(options[:rest_endpoint], conf.at(1)['Parameters']['name'], 'delete',
                                                 conf.at(1)['Parameters'])
            puts 'deleted SecIP List ' + conf.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end
        elsif func == 'secassoc'
          networkconfig = SecAssoc.new(options[:id_domain], options[:user_name], options[:passwd])
          case conf.at(1)['Action']
          when 'create'
            networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', conf.at(1)['Parameters'])
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'modify'
            puts 'nothing done yet'
          when 'delete'
            networkconfig = networkconfig.update(options[:rest_endpoint], conf.at(1)['Parameters']['name'], 'delete',
                                                 conf.at(1)['Parameters'])
            puts 'deleted Secassoc ' + app.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end
        elsif func == 'ip'
          networkconfig = IPUtil.new(options[:id_domain], options[:user_name], options[:passwd])
          callclass = conf.at(1)['Class']
          case conf.at(1)['Action']
          when 'create'
            networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', callclass, conf.at(1)['Parameters'])
            puts JSON.pretty_generate(JSON.parse(networkconfig.body))
          when 'modify'
            puts 'nothing done yet'
          when 'delete'
            networkconfig = networkconfig.update(options[:rest_endpoint], conf.at(1)['Parameters']['name'], 'delete',
                                                 callclass, conf.at(1)['Parameters'])
            puts 'deleted IP ' + callclass + ' ' + conf.at(1)['Parameters']['name'] if networkconfig.code == '204'
          end
        end # end of if
      end
    end # end of loop for inputdata
  end  # end create method
end # end of class
