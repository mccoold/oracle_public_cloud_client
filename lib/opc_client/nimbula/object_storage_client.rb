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
class ObjectStorageClient < NimbulaClient
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse = InputParse.new(args)
    @options = inputparse.storage_create
    attrcheck = { 'Action' => @options[:action] }
    @validate = Validator.new
    @util = Utilities.new
    @validate.attrvalidate(@options, attrcheck)
    case @options[:action].downcase
    when 'create'
      create
    when 'list'
      list
    when 'delete'
      delete
    else
      abort('you entered an invalid selection for Action')
    end
  end

  # create new object storage container
  def create # rubocop:disable Metrics/AbcSize
    attrcheck = { 'container name' => @options[:container] }
    @validate.attrvalidate(@options, attrcheck)
    newcontainer = ObjectStorage.new(@options[:id_domain], @options[:user_name], @options[:passwd])
    newcontainer = newcontainer.create(@options[:container])
    if newcontainer.code == '201'
      puts "Container #{@options[:container]} created"
    else
      @util.response_handler(newcontainer)
    end 
  end 

  # list containers and contents in the container, to see the contents of the container
  # include the container in the call
  def list # rubocop:disable Metrics/AbcSize
    if @options[:container]
      containerview = ObjectStorage.new(@options[:id_domain], @options[:user_name], @options[:passwd])
      containerview = containerview.contents(@options[:container])
      if containerview.code == '201' || containerview.code == '200'
        containerview.body
      elsif containerview.code == '204'
        print 'the container is empty'
      else
        @util.response_handler(containerview)
      end
    else
      newcontainer = ObjectStorage.new(@options[:id_domain], @options[:user_name], @options[:passwd])
      newcontainer = newcontainer.list
      @util.response_handler(newcontainer)
      newcontainer.body if newcontainer.code == '200'
      puts 'there are no containers' if newcontainer.code == '204'
    end 
  end 

  # delete the contents of a container and a container
  # will do recursive delete on content in the container
  def delete # rubocop:disable Metrics/AbcSize
    attrcheck = { 'container name' => @options[:container] }
    @validate.attrvalidate(@options, attrcheck)
    containerview = ObjectStorage.new(@options[:id_domain], @options[:user_name], @options[:passwd])
    if @options[:recurse]
      contents = containerview.contents(@options[:container])
      container_contents = contents.body.split(/\n/)
      container_contents.each do |content|
        containerview.delete_content(@options[:container], content)
        puts 'deleted ' + content
      end
    end
    containerview = containerview.delete(@options[:container])
    if containerview.code == '204'
      puts "Container #{@options[:container]} deleted"
    else
      @util.response_handler(containerview)
    end
  end

  def content_upload(args) # rubocop:disable Metrics/AbcSize
    inputparse = InputParse.new(args)
    @options = inputparse.storage_create
    attrcheck = {
      'file_2_upload'   => @options[:file_name],
      'object_2_create' => @options[:object_name]
    }
    @validate.attrvalidate(@options, attrcheck)
    newcontent = ObjectStorage.new(@options[:id_domain], @options[:user_name], @options[:passwd])
    newcontent = newcontent.object_create(@options[:file_name], @options[:container], @options[:object_name],
                                          @options[:file_type])
    if newcontent.code == '201'
      puts newcontent.code
      puts "Object #{@options[:file_name]} has been created in container #{@options[:container]}"
    else
      puts newcontent.body
    end
  end
end
