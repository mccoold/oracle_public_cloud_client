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
class OrchClient < OpcClient
  def request_handler(args)
    inputparse =  InputParse.new(args)
    options = inputparse.create
    attrcheck = { 'Action'    => options[:action] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    abort(valid.at(1)) if valid.at(0) == 'true'
    case options[:action]
    when 'create'
      create(options)
    when 'list'
      list(options)
    else
      abort('you entered an invalid selection for Action') 
    end
  end
  
  def create(options)
    dgcreate = DataGrid.new(options[:id_domain], options[:user_name], options[:passwd])
    createcall = dgcreate.create(options[:inst])
    if createcall.code == '400'
      puts 'error'
      puts createcall.body
    else
      puts createcall.body
    end
  end  # end create method
 
  def list(options) 
    result = DataGrid.new(options[:id_domain], options[:user_name], options[:passwd])
    if options[:backup_id].nil?
      result = result.backup_list(options[:inst])
    else
      result = result.backup_list(options[:inst])
    end
    if result.code == '401' || result.code == '400' || result.code == '404'
      puts 'error, JSON was not returned  the http response code was' + result.code
    else
      JSON.pretty_generate(JSON.parse(result.body))
    end # end of if
  end # end of method
end # end of class
