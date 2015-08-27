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
# limitations under the License
#
class IaasClient < OpcClient
  #
  require 'OPC/Iaas/storage'
  require 'OPC/Util/encrypt'

  def storage_token(args)
    inputparse =  InputParse.new(args)
    options = inputparse.storagecreate
    Storage.getToken("#{options[:id_domain]}", "#{options[:user_name]}", "#{options[:passwd]}")
  end

  def storage_create(args)
    inputparse =  InputParse.new(args)
    options = inputparse.storage_create
    attrcheck = nil
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      newcontainer = Storage.new
      newcontainer = newcontainer.create("#{options[:id_domain]}", "#{options[:user_name]}",
                                         "#{options[:passwd]}", "#{options[:container]}")
      if newcontainer.code == '201'
        puts newcontainer.code
        puts "Container #{options[:container]} created"
      else
        puts newcontainer.body
      end # end of if
    end # end of validator
  end # end of method

  def storage_list(args)
    inputparse =  InputParse.new(args)
    options = inputparse.storage_create
    attrcheck = nil
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      if options[:container]
        containerview = Storage.new
        containerview = containerview.contents("#{options[:id_domain]}", "#{options[:user_name]}",
                                               "#{options[:passwd]}", "#{options[:container]}")
        if containerview.code == '201'
          puts containerview.code
          # puts "Container #{options[:container]} created"
          puts containerview.body
        else
          puts containerview.body
        end # end of inside if
      else
        newcontainer = Storage.new
        newcontainer = newcontainer.list("#{options[:id_domain]}", "#{options[:user_name]}", "#{options[:passwd]}")
        if newcontainer.code == '201'
          puts newcontainer.code
          # puts "Container #{options[:container]} created"
          puts newcontainer.body
        else
          puts newcontainer.body
        end # end of inside if
      end # end of outside if
    end # end of validator
  end # end of method

  def container_delete(args)
    inputparse =  InputParse.new(args)
    options = inputparse.storage_create
    containerview = Storage.new
    containerview = containerview.delete("#{options[:id_domain]}", "#{options[:user_name]}",
                                         "#{options[:passwd]}", "#{options[:container]}")
    if containerview.code == '201'
      puts containerview.code
      # puts "Container #{options[:container]} created"
      puts containerview.body
    else
      puts containerview.body
    end # end of if
  end # end of method

def content_upload(args)
    inputparse =  InputParse.new(args)
    options = inputparse.storage_create
    attrcheck = {
      'file_2_upload'   => options[:file_name],
      'object_2_create' => options[:object_name]}
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      newcontent = Storage.new
      newcontent = newcontent.object_create("#{options[:file_name]}", "#{options[:container]}", "#{options[:object_name]}",
                                "#{options[:file_type]}", "#{options[:id_domain]}", "#{options[:user_name]}", "#{options[:passwd]}")
      if newcontent.code == '201'
        puts newcontent.code
        puts "Object #{options[:file_name]} has been created in container #{options[:container]}"
      else
        puts newcontent.body
      end # end of if
    end # end of validator
  end # end of method
  
  def encrypt_content_upload(args)
    inputparse =  InputParse.new(args)
    options = inputparse.storage_create
    attrcheck = nil
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      encryptobject = Encrypt.new
      encryptcontent = encryptobject.encrypt("#{options[:object_name]}", "#{options[:file_name]}", 
                                             "#{options[:id_domain]}", "#{options[:user_name]}", "#{options[:passwd]}")
    end # end of validator
  end # end of method
  
  def decrypt_content_upload(args)
    inputparse =  InputParse.new(args)
    options = inputparse.storage_create
    attrcheck = nil
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      encryptobject = Encrypt.new
      encryptcontent = encryptobject.decrypt("#{options[:object_name]}", "#{options[:file_name]}", 
                                             "#{options[:id_domain]}", "#{options[:user_name]}", "#{options[:passwd]}")
    end # end of validator
  end # end of method
end # end of class



