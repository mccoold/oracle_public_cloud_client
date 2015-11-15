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
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    options = inputparse.compute('compute')
    attrcheck = { 'Action' => options[:action] }
    @validate = Validator.new
    @validate.attrvalidate(options, attrcheck)
    case options[:action].downcase
    when 'list'
      list(options)
    else
      abort('You entered an invalid selection for Action')
    end # end case
  end # end method

  def list(options) # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => options[:rest_endpoint],
      'Container'       => options[:container] }
    @validate.attrvalidate(options, attrcheck)
    instanceconfig = Instance.new(options[:id_domain], options[:user_name], options[:passwd])
    instanceconfig = instanceconfig.list(options[:rest_endpoint], options[:container])
    puts JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end # end of method
end # end of class
