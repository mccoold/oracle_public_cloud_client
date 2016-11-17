#Author:: Daryn McCool (<mdaryn@hotmail.com>)
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
class PaasHelpers < NimbulaClient
  # create monitor method for paas calls
  def create_result(options, createcall, function)  # rubocop:disable Metrics/AbcSize
      status_object = function.create_status(createcall['location'])
      status_message =  status_object.body # have to break all the calls out for error handling,
      # The REST end point tends not to be consistant
      status_message_status = JSON.parse(status_message) if status_object.code == '202'
      puts 'building ' + status_message_status['service_name'] unless options[:action] == 'start' || options[:action] == 'stop'
      puts JSON.pretty_generate(status_message_status) if options[:action] == 'start' || options[:action] == 'stop'
      if options[:track]
        breakout = 1
        # tracking the build
        while status_message_status['status'] == 'In Progress' || status_message_status['status'] == 'Provisioning completed'
          print '.'
          sleep 25
          status_object = function.create_status(createcall['location'])
          status_message =  status_object.body
          status_message_status = JSON.parse(status_message) if status_object.code == '202' || status_object.code == '200'
          # the API's tended to be a bit flaky for a while so extra error handling
          if status_object.code == '500'
            breakkout +=
            abort('Rest calls failing 5 times ' + status_object.code) if breakout == 5
          end
        end
        result = SrvList.new(options[:id_domain], options[:user_name], options[:passwd], options[:function])
        options[:paas_rest_endpoint] = paas_url(options[:paas_rest_endpoint], options[:function]) if options[:paas_rest_endpoint]
        result.url = options[:paas_rest_endpoint] if options[:paas_rest_endpoint]
        puts status_message_status['service_name']
        result = result.inst_list(status_message_status['service_name'])
        puts JSON.pretty_generate(JSON.parse(result.body))
      end 
    end 
    
  def paas_url(options) # rubocop:disable Metrics/AbcSize
    full_url = options[:paas_rest_endpoint] + '/paas/service/jcs/api/v1.1/instances/' + options[:id_domain] if options[:function] == 'jcs'
    full_url = options[:paas_rest_endpoint] + '/paas/service/dbcs/api/v1.1/instances/' + options[:id_domain] if options[:function] == 'dbcs'
    full_url = options[:paas_rest_endpoint] + 'paas/service/soa/api/v1.1/instances/' + options[:id_domain] if options[:function] == 'soa'
    return full_url
  end
end