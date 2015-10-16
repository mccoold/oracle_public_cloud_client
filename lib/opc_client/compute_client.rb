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
class ComputeClient < OpcClient
  def instance_list(args)
    inputparse =  InputParse.new(args)
    options = inputparse.compute
    attrcheck = {
      'Instance'  => options[:rest_endpoint],
      'Container' => options[:container] }
    validate = Validator.new
    valid = validate.attrvalidate(options, attrcheck)
    if valid.at(0) == 'true'
      puts valid.at(1)
    else
      instanceconfig = Instance.new
      instanceconfig = instanceconfig.list(options[:rest_endpoint], options[:container], options[:id_domain],
                                           options[:user_name], options[:passwd])
      puts JSON.pretty_generate(JSON.parse(instanceconfig.body))
    end # end of validator
  end # end of method
end # end of class
