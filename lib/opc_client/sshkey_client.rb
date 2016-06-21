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
class SshkeyClient < OpcClient
  def list(options) # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    options[:action].downcase
    if options[:action] == 'list' || options[:action] == 'details'
      networkconfig = SshKey.new(options[:id_domain], options[:user_name], options[:passwd], options[:rest_endpoint])
      networkconfig.sshkey = options[:container]
      networkconfig = networkconfig.list(options[:action])
      @util.response_handler(networkconfig)
      return JSON.pretty_generate(JSON.parse(networkconfig.body))
    else
      puts 'invalid entry for action, please use details or list'
    end # end of if
  end # end of method

  def update(options) # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    networkconfig = SshKey.new(options[:id_domain], options[:user_name], options[:passwd], options[:rest_endpoint])
    case options[:action]
    when 'create'
      file = File.read(options[:create_json])
      updates = JSON.parse(file)
      networkconfig.create_data = updates
      networkconfig.sshkey = options[:container]
      networkupdate = networkconfig.update(options[:action])
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    when 'delete'
      networkconfig.sshkey = options[:container]
      networkupdate = networkconfig.update(options[:action])
      return 'deleted  ' + options[:container]
    else
      puts 'invalid entry for action'
    end # end of case
  end # end of method
end
