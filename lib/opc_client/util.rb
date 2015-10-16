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
class Utilities < OpcClient
  def create_result(options, createcall, function, caller)
    res = JSON.parse(function.create_status(createcall['location'], options[:id_domain],
                                            options[:user_name], options[:passwd]))
    puts 'building ' + res['service_name']
    if options[:track]
      while res['status'] == 'In Progress'
        print '.'
        sleep 25
        res = JSON.parse(function.create_status(createcall['location'], options[:id_domain],
                                                options[:user_name], options[:passwd]))
      end # end of while
      if "#{caller}" == 'db'
        result = DbServiceList.new
      elsif "#{caller}" == 'jcs'
        result = SrvList.new
      else
        print 'in the else, something went wrong'
        puts "#{caller}"
      end
      puts res['service_name']
      result = result.inst_list(options[:id_domain], options[:user_name],
                                options[:passwd], res['service_name'])
      puts JSON.pretty_generate(JSON.parse(result.body))
    end # end of track if
  end # end of method

  def encrypt_content_upload(args)
    inputparse =  InputParse.new(args)
    options = inputparse.storage_create
    attrcheck = {
      'object'    => options[:object_name],
      'file name' => options[:file_name] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      encryptobject = Encrypt.new
      encryptobject.encrypt(options[:object_name], options[:file_name],
                            options[:id_domain], options[:user_name], options[:passwd]) if options[:action] == 'encrypt'
      encryptobject.decrypt(options[:object_name], options[:file_name],
                            options[:id_domain], options[:user_name], options[:passwd]) if options[:action] == 'decrypt'
    end # end of validator
  end # end of method
end # end of class
