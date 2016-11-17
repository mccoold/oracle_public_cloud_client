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
  def config_file
    config_file_handler = OPC.new
    config_files = config_file_handler.cfgfile
  end
  
  def config_file_reader(options)
    file_values = config_file
    if !file_values.nil?
      values = { 
        'id_domain'          => :id_domain,
        'user_name'          => :user_name,
        'rest_endpoint'      => :rest_endpoint,
        'paas_rest_endpoint' => :paas_rest_endpoint,
        'tenancy'            => :tenancy,
        'key_file'           => :key_file,
        'fingerprint'        => :fingerprint,
        'bmcenable'          => :bmcenable,
        'debug'              => :debug,
        'bmc_user'           => :user,
        'region'             => :region,
        'pass_phrase'        => :pass_phrase,
        'log_requests'       => :log_requests,
        'verify_certs'       => :verify_certs,
        'compartment'        => :compartment
      }
      values.each_pair do |k, v|
        if options[v].nil?
         options[v] = file_values[k] unless file_values[k].nil?
        end
      end
    end
    return options
  end
  
  def response_handler(response)
    case response.code 
    when '400', '404', '409', '401', '500', '403'
      if response.body.nil? || response.body.empty?
        abort('error, the error response code is ' + response.code)
      else
        abort('Error!! the error response code is ' + response.code + ' error message is ' + response.body)
      end
    else
      return response
    end  
  end
end # end of class
