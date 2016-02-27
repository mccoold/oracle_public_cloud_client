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
class PaasList < OpcClient
  def srvice_list(args)
    inputparse =  InputParse.new(args)
    @options = inputparse.inst_list('list')
    attrcheck = { 'Action' => @options[:action] }
    @validate = Validator.new
    @validate.attrvalidate(@options, attrcheck)
    util_service_list
  end  # end of method list

  def util_service_list # rubocop:disable Metrics/AbcSize
    list_result = SrvList.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:action])
    list_result.url = @options[:rest_endpoint] if @options[:rest_endpoint]
    if @options[:inst]
      inst_list(list_result)
    else
      result = list_result.service_list
      print 'error, JSON was not returned  the http response code was ' +
        result.code if result.code == '401' || result.code == '404'
      JSON.pretty_generate(JSON.parse(result.body)) unless result.code == '401' || result.code == '404'
    end # end of inst if
  end # end of method

  def inst_list(result) # rubocop:disable Metrics/AbcSize
    if @options[:mang] == 'true'
      result.server_name = @options[:serverid] if @options[:serverid]
      result = result.managed_list(@options[:inst])
      puts JSON.pretty_generate(JSON.parse(result.body)) if result.code == '200'
      puts 'error in requrest' + result.code unless result.code == '200'
    else # inside mang else
      result = result.inst_list(@options[:inst])
      case @options[:action].downcase
      when 'jcs', 'soa'
        return JSON.pretty_generate(JSON.parse(result.body)) unless result.code == '401' || result.code == '404'
        abort('error, JSON was not returned  the http response code was ' +
        result.code) if result.code == '401' || result.code == '404'
      when 'dbcs'
        unless result.code == '401' || result.code == '404'
          result_json = JSON.parse(result.body)
          ssh_host = (result_json['glassfish_url'])
          ssh_host.delete! 'https://'
          ssh_host.slice!('4848')
          puts "#{ssh_host}"
          puts JSON.pretty_generate(result_json)
        end # end of unless
        abort('error, JSON was not returned  the http response code was ' +
          result.code) if result.code == '401' || result.code == '404'
      else
        print 'what are you sending? It is not correct'
      end # end of case
    end # end of inst if
  end # end of method
end # end of class
