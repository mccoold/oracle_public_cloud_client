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
class IPUtilClient < OpcClient
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    @options = inputparse.compute('iputil')
    @util = Utilities.new
    attrcheck = { 'Action' => @options[:action],
                  'RestEndPoint' => @options[:rest_endpoint],
                  'Function' => @options[:function]
    }
    @validate = Validator.new
    @validate.attrvalidate(@options, attrcheck)
    case @options[:action].downcase
    when 'list', 'details'
      list
    when 'create'
      create
    when 'delete'
      delete
    when 'update'
      update
    else
      abort('You entered an invalid selection for Action')
    end # end case
    @iputil = IPUtil.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    @function = 'association' if @options[:function] == 'ip_association'
    @function = 'reservation' if @options[:function] == 'ip_reservation'
  end # end method

  attr_writer :options

  def list # rubocop:disable Metrics/AbcSize
    attrcheck = { 'Container' => @options[:container] }
    @validate.attrvalidate(@options, attrcheck)
    networkconfig = @iputil.list(@options[:container], @options[:action], @function)
    @util.response_handler(networkconfig)
    return JSON.pretty_generate(JSON.parse(networkconfig.body))
  end # end of method

  def update # rubocop:disable Metrics/AbcSize
    attrcheck = { 'Container' => @options[:container] }
    @validate.attrvalidate(@options, attrcheck)
    key_sep = '='
    updates = {}
    @options[:list].each do |v|
      key_value = v.split(key_sep)
      updates[key_value.at(0)] = key_value.at(1)
    end # end of parsing through the update parameters
    networklist = @iputil.list(@options[:container])
    data = JSON.parse(networklist.body).first
    data1 = data.at(1)
    update = data1.at(0)
    updates.each do |k, v|
      update[k] = v
    end
    networkupdate.create_json = update
    networkupdate = @iputil.update(@options[:action], @function)
    @util.response_handler(networkupdate)
    JSON.pretty_generate(JSON.parse(networkupdate.body))
  end # end of method

  def create
    file = File.read(@options[:create_json])
    update = JSON.parse(file)
    networkupdate.create_json = update
    networkupdate = @iputil.update(@options[:action], @function)
    @util.response_handler(networkupdate)
    JSON.pretty_generate(JSON.parse(networkupdate.body))
  end # end of method

  def delete
    networkupdate.ipcontainer_name = @options[:container]
    networkupdate = @iputil.update(@options[:action], @function)
    @util.response_handler(networkupdate)
    JSON.pretty_generate(JSON.parse(networkupdate.body))
  end # end of method
end
