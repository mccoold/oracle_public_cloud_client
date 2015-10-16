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
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      file = File.read(options[:create_json])
      inputdata = JSON.parse(file)
      inputdata.each do |app| 
        func = app.at(0).downcase 
        if func == 'secapp'
          case app.at(1)['Action']
            when 'create'
              networkconfig = SecApp.new(options[:id_domain], options[:user_name], options[:passwd])
              networkconfig = networkconfig.modify(options[:rest_endpoint], 'create', app.at(1)['Parameters'])
              puts JSON.pretty_generate(JSON.parse(networkconfig.body))
            when 'delete'
              puts 'delete'
          end
        elsif func == 'secrule'
          case app.at(1)['Action']
            when 'create'
              networkconfig = SecRule.new(options[:id_domain], options[:user_name], options[:passwd])
              networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', app.at(1)['Parameters'])
              puts JSON.pretty_generate(JSON.parse(networkconfig.body))
            when 'modify'
              puts 'nothing done yet'
            when 'delete'
              puts 'delete'
          end
        elsif func == 'seclist'
          case app.at(1)['Action']
            when 'create'
              networkconfig = SecList.new(options[:id_domain], options[:user_name], options[:passwd])
              networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', app.at(1)['Parameters'])
              puts JSON.pretty_generate(JSON.parse(networkconfig.body))
            when 'modify'
              puts 'nothing done yet'
            when 'delete'
              puts 'delete'
          end
        elsif func == 'seciplist'
          case app.at(1)['Action']
            when 'create'
              networkconfig = SecIPList.new(options[:id_domain], options[:user_name], options[:passwd])
              networkconfig = networkconfig.update(options[:rest_endpoint], nil, 'create', app.at(1)['Parameters'])
              puts JSON.pretty_generate(JSON.parse(networkconfig.body))
            when 'modify'
              puts 'nothing done yet'
            when 'delete'
              puts 'delete'
          end
        end
      end
    end # end of validator if
  end  # end create method
end
  # puts 'outside'
      #  puts app.at(0)
     #   puts app.at(1)['Action']
     #   puts app.at(1)['Parameters']
     #   puts 'starting secon'
     #   app.at(1).each do |dal|
     #     puts 'in deep'
     #     puts dal.at(0)
     #     puts 'what to do'
     #     puts dal.at(1)
     #     puts dal.at(2)
     #     puts 'done'
     #     end
  