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
class Validator < OpcClient
  def attrvalidate(options, attrcheck)
    if options[:id_domain].nil?
      validateresponse = 'id domain is null, it can not be empty. use -h flag for list of arguements'
      validate = true
      return "#{validate}", "#{validateresponse}"
    elsif options[:passwd].nil?
      validateresponse = 'password is null, it can not be empty. use -h flag for list of arguements'
      validate = true
      return "#{validate}", "#{validateresponse}"
    elsif options[:user_name].nil?
      validateresponse = 'user name is null, it can not be empty. use -h flag for list of arguements'
      validate = true
      return "#{validate}", "#{validateresponse}"
    elsif !attrcheck.nil?
      attrcheck.each do |key, attr|
        if attr.nil?
          validateresponse = "#{key}" + ' is null, it can not be empty. use -h flag for list of arguements'
          validate = true
          return "#{validate}", "#{validateresponse}"
        else
          validateresponse = 'passed validator'
          validate = false
          return "#{validate}", "#{validateresponse}"
        end # end of if
      end # end of loop
    else
      validateresponse = 'passed validator'
      validate = false
      return "#{validate}", "#{validateresponse}"
    end # end of if
  end # end of method
end
