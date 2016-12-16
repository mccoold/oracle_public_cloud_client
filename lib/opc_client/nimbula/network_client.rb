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
class NetworkClient < NimbulaClient
  require 'opc_client/nimbula/helpers'
  include NimbulaHelpers::NimCommandLine 
  def initialize
    @validate = Validator.new
  end
  
  def optparse
    attrcheck = {
          'Service'       => @options[:function],
          'Action'        => @options[:action],
          'RestEndPoint'  => @options[:rest_endpoint]
        }
    @validate.attrvalidate(@options, attrcheck)
    case @options[:function].downcase
    when 'secrule'
      secrule = SecRuleClient.new
      case @options[:action].downcase
      when 'list', 'details'
        secrule.list(@options)
      when 'update', 'create', 'delete'
        secrule.update(@options)
      else
        abort('you entered an incorrect action')
      end
    when 'secapp'
      secapp = SecAppClient.new
      case @options[:action].downcase
      when 'list', 'details'
        secapp.list(@options)
      when 'create', 'delete'
        secapp.modify(@options)
      else
        abort('you entered an incorrect action')
      end
    when 'seclist'
      seclist = SecListClient.new
      case @options[:action].downcase
      when 'list', 'details'
        seclist.list(@options)
      when 'create', 'delete'
        seclist.update(@options)
      else
        abort('you entered an incorrect action')
      end
    when 'secassoc'
      secassoc = SecAssocClient.new
      case @options[:action].downcase
      when 'list', 'details'
        secassoc.list(@options)
      when 'create', 'delete'
        secassoc.update(@options)
      else
        abort('you entered an incorrect action')
      end
    when 'ipnetwork'
      ipnetwork = IpNetworkClient.new
      case @options[:action].downcase
      when 'list', 'details'
        ipnetwork.list(@options)
      when 'create', 'delete'
        ipnetwork.update(@options)
      else
        abort('you entered an incorrect action')
      end
    when 'seciplist'
      seciplist = SecIPListClient.new
      case @options[:action].downcase
      when 'list', 'details'
        seciplist.list(@options)
      when 'create', 'delete', 'update'
        seciplist.update(@options)
      else
        abort('you entered an incorrect action')
      end
    when 'ip_reservation', 'ip_association'
      iputilc = IPUtilClient.new
      @options[:function] = @argsfunction
      iputilc.options = @options
      case @options[:action].downcase
      when 'list', 'details'
        iputilc.list
      when 'create',
        iputilc.create
      when 'delete'
        iputilc.delete
      when 'update'
        iputilc.update
      else
        abort('you entered an incorrect action')
      end
    when 'ssh_key'
      sshkey = SshkeyClient.new
      case @options[:action].downcase
      when 'list', 'details'
        sshkey.list(@options)
      when 'create', 'delete', 'update'
        sshkey.update(@options)
      else
        abort('you entered an incorrect action')
      end
    else
      abort('you entered and incorrect function')
    end
  end
  attr_writer :argsfunction
end
