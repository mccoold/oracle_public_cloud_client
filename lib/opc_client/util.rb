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
  def create_result(options, createcall, function)  # rubocop:disable Metrics/AbcSize
    status_object = function.create_status(createcall['location'])
    status_message =  status_object.body # have to break all the calls out for error handling,
    # The REST end point tends not to be consistant
    status_message_status = JSON.parse(status_message) if status_object.code == '202'
    puts 'building ' + status_message_status['service_name'] unless options[:action] == 'start' || options[:action] == 'stop'
    puts JSON.pretty_generate(status_message_status) if options[:action] == 'start' || options[:action] == 'stop'
    if options[:track]
      breakout = 1
      while status_message_status['status'] == 'In Progress' || status_message_status['status'] == 'Provisioning completed'
        print '.'
        sleep 25
        status_object = function.create_status(createcall['location'])
        status_message =  status_object.body
        status_message_status = JSON.parse(status_message) if status_object.code == '202' || status_object.code == '200'
        if status_object.code == '500'
          breakkout++
          abort('Rest calls failing 5 times ' + status_object.code) if breakout == 5
        end # end of if
      end # end of while
      result = SrvList.new(options[:id_domain], options[:user_name], options[:passwd], options[:action])
      puts status_message_status['service_name']
      result = result.inst_list(status_message_status['service_name'])
      puts JSON.pretty_generate(JSON.parse(result.body))
    end # end of track if
  end # end of method

  def encrypt_content_upload(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    options = inputparse.storage_create
    attrcheck = {
      'object'    => options[:object_name],
      'file name' => options[:file_name] }
    @validate = Validator.new
    @validate.attrvalidate(options, attrcheck)
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
