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
    options = inputparse.inst_list
    attrcheck = nil
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      util = PaasListUtil.new(options)
      util.util_service_list(SrvList)
    end # end of validator if
  end  # end of method list
end # end of class

class PaasListUtil < OpcClient # search util class
  def initialize(options)
    @options = options
  end

  def util_service_list(function)
    result = function.new(@options[:id_domain], @options[:user_name], @options[:passwd])
    if @options[:inst]
      search = PaasListUtil.new(@options)
      search.inst_jcs(result)
    else
      result = result.service_list(@options[:action])
      print 'error, JSON was not returned  the http response code was ' +
        result.code if result.code == '401' || result.code == '404'
      JSON.pretty_generate(JSON.parse(result.body)) unless result.code == '401' || result.code == '404'
    end # end of inst if
  end # end of method

  def inst_jcs(result)
    if @options[:mang]
      result = result.managed_list(@options[:action], @options[:inst])
      puts JSON.pretty_generate(result)
    else # inside mang else
      result = result.inst_list(@options[:action],  @options[:inst])                     
      if @options[:action] == 'jcs'
        puts JSON.pretty_generate(JSON.parse(result.body)) unless result.code == '401' || result.code == '404'
        print 'error, JSON was not returned  the http response code was ' +
          result.code if result.code == '401' || result.code == '404'
      elsif @options[:action] == 'dbcs'
        unless result.code == '401' || result.code == '404'
          results = JSON.parse(result.body)
          ssh_host = (results['glassfish_url'])
          ssh_host.delete! 'https://'
          ssh_host.slice!('4848')
          puts "#{ssh_host}"
          puts JSON.pretty_generate(results)
        end # end of unless
        print 'error, JSON was not returned  the http response code was ' +
          result.code if result.code == '401' || result.code == '404'
      else
        puts 'what are you sending? It is not correct'
      end # end of little if here
    end # end of inst if
  end # end of method
end # end of class
