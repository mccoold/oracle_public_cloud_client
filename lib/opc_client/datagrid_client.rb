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
class DataGridClient < OpcClient
  #
  require 'opc/paas/jcs/datagrid'
  #
  def create(args)
    inputparse =  InputParse.new(args)
    options = inputparse.create
    dgcreate = InstCreate.new
    createcall = dgcreate.create(options[:inst], options[:id_domain], options[:user_name], options[:passwd])
    if createcall.code == '400'
      puts 'error'
      puts createcall.body
    else
      res = dgcreate.create_status(createcall['location'], options[:id_domain], options[:user_name],
                                   options[:passwd])
      puts 'building ' + res['service_name']
      if options[:track]
        while res['status'] == 'In Progress'
          print '.'
          sleep 25
          res = dgcreate.create_status(createcall['location'], options[:id_domain], options[:user_name],
                                       options[:passwd])
          res = JSON.parse(res)
        end # end of while
        result = SrvList.new
        puts res['service_name']
        result = result.inst_list(options[:id_domain], options[:user_name], options[:passwd], res['service_name'])
        result = JSON.parse(result)
        result = JSON.pretty_generate(result)
        puts "#{result}"
      end # end of track if
    end # end of main if
  end  # end create method
end # end of class
