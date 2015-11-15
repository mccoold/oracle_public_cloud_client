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
class PaasClient < OpcClient
  
  def create(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    options = inputparse.create
    attrcheck = {
      'create_json'   => options[:create_json],
      'Action'        => options[:action] }
    @validate = Validator.new
    @validate.attrvalidate(options, attrcheck)
    file = File.read(options[:create_json])
    data_hash = JSON.parse(file)
    opccreate = InstCreate.new(options[:id_domain], options[:user_name], options[:passwd])
    createcall = opccreate.create(data_hash, options[:action])
    if createcall.code == '400' || createcall.code == '404' || createcall.code == '401'
      puts 'Error with the REST Call'
      puts createcall.code
      puts createcall.body
    else
      function = opccreate
      util = Utilities.new
      util.create_result(options, createcall, function)
    end # end of main if
    # end # end of validator if
  end  # end create method

  def delete(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    options = inputparse.delete
    attrcheck = { 'Instance' => options[:inst] }
    @validate = Validator.new
    @validate.attrvalidate(options, attrcheck)
    deleteconfig = File.read(options[:config]) if options[:action] == 'jcs'
    data_hash = JSON.parse(deleteconfig) if options[:action] == 'jcs'
    deleteinst = InstDelete.new(options[:id_domain], options[:user_name], options[:passwd])
    result = deleteinst.delete(options[:action], data_hash, options[:inst]) if options[:action] == 'jcs'
    result = deleteinst.delete(options[:action], nil, options[:inst]) if options[:action] == 'dbcs'
    puts JSON.pretty_generate(JSON.parse(result.body)) if result.code == '202'
    puts result.body + result.code unless result.code == '202'
  end # end of method
end # end of class
