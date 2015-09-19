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
  def util_service_list(options, caller, function)
    result = function.new
    if options[:inst]
      if options[:mang]
        result = result.managed_list("#{options[:id_domain]}", "#{options[:user_name]}",
                                     "#{options[:passwd]}", "#{options[:inst]}")
        puts JSON.pretty_generate(result)
      else # inside else
        result = result.inst_list("#{options[:id_domain]}", "#{options[:user_name]}",
                                  "#{options[:passwd]}", "#{options[:inst]}")
        if caller.nil?
          puts JSON.pretty_generate(JSON.parse(result.body)) unless result.code == '401' or result.code == '404'
          print 'error, JSON was not returned  the http response code was ' + result.code if result.code == '401' or result.code == '404' 
        elsif caller == 'db'
          unless result.code == '401' or result.code == '404'
            results = JSON.parse(result.body)
            ssh_host = (results['glassfish_url'])
            ssh_host.delete! 'https://'
            ssh_host.slice!("4848")
            puts "#{ssh_host}"
            puts results = JSON.pretty_generate(results)
          end # end of unless
          print 'error, JSON was not returned  the http response code was ' + result.code if result.code == '401' or result.code == '404'
        else
          puts 'what are you sending? It is not correct'
        end # end of little if here
      end # end of manage if 
    else
      result = result.service_list("#{options[:id_domain]}", "#{options[:user_name]}", "#{options[:passwd]}") 
      puts result.code
      print 'error, JSON was not returned  the http response code was ' + result.code if (result.code == '401' or result.code == '404')
      JSON.pretty_generate(JSON.parse(result.body)) unless result.code == '401' or result.code == '404'
    end # end of inst if
  end # end of method

  def create_result(options, createcall, function, caller)
    res = JSON.parse(function.create_status(createcall['location'], "#{options[:id_domain]}",
                                            "#{options[:user_name]}", "#{options[:passwd]}"))
    puts 'building ' + res['service_name']
    if options[:track]
      while res['status'] == 'In Progress'
        print '.'
        sleep 25
        res = JSON.parse(function.create_status(createcall['location'], "#{options[:id_domain]}",
                                                "#{options[:user_name]}", "#{options[:passwd]}"))
      end # end of while
      if "#{caller}" == 'db'
        result = DbServiceList.new
      elsif "#{caller}" == 'jcs'
        result = SrvList.new
      else
        print 'in the else, something went wrong'
        puts "#{caller}"
      end
      puts res['service_name']
      result = result.inst_list("#{options[:id_domain]}", "#{options[:user_name]}",
                                "#{options[:passwd]}", res['service_name'])
      JSON.pretty_generate(JSON.parse(result.body))
    end # end of track if
  end # end of method
end # end of class
