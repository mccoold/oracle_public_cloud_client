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
    options = inputparse.inst_list('list')
    attrcheck = {'Action' => options[:action] }
    @validate = Validator.new
    @validate.attrvalidate(options, attrcheck)
    util = PaasListUtil.new(options)
    util.util_service_list(SrvList)
  end  # end of method list
end # end of class

class PaasListUtil < OpcClient # search util class
  def initialize(options)
    @options = options
  end

  def util_service_list(function) # rubocop:disable Metrics/AbcSize
    result = function.new(@options[:id_domain], @options[:user_name], @options[:passwd])
    if @options[:inst]
      search = PaasListUtil.new(@options)
      search.inst(result)
    else
      result = result.service_list(@options[:action])
      print 'error, JSON was not returned  the http response code was ' +
        result.code if result.code == '401' || result.code == '404'
      JSON.pretty_generate(JSON.parse(result.body)) unless result.code == '401' || result.code == '404'
    end # end of inst if
  end # end of method

  def inst(result) # rubocop:disable Metrics/AbcSize
    if @options[:mang]
      result = result.managed_list(@options[:inst])
      puts JSON.pretty_generate(result)
    else # inside mang else
      result = result.inst_list(@options[:action],  @options[:inst])
      if @options[:action].downcase == 'jcs'
        puts JSON.pretty_generate(JSON.parse(result.body)) unless result.code == '401' || result.code == '404'
        print 'error, JSON was not returned  the http response code was ' +
          result.code if result.code == '401' || result.code == '404'
      elsif @options[:action].downcase == 'dbcs'
        unless result.code == '401' || result.code == '404'
          result_json = JSON.parse(result.body)
          ssh_host = (result_json['glassfish_url'])
          ssh_host.delete! 'https://'
          ssh_host.slice!('4848')
          puts "#{ssh_host}"
          puts JSON.pretty_generate(result_json)
        end # end of unless
        print 'error, JSON was not returned  the http response code was ' +
          result.code if result.code == '401' || result.code == '404'
      else
        puts 'what are you sending? It is not correct'
      end # end of little if here
    end # end of inst if
  end # end of method
end # end of class
