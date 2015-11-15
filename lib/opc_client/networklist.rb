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
# WITHOUT WARRANTIE S OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class NetworkList < OpcClient
  def network_list(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    options = inputparse.compute('networklist')
    attrcheck = {
      'Action'          => options[:action],
      'Rest End Point'  => options[:rest_endpoint],
      'Container'       => options[:container],
      'Function'        => options[:function] }
    @validate = Validator.new
    @validate.attrvalidate(options, attrcheck)
    case options[:function].downcase
    when 'seclist'
      seclistc = SecListClient.new
      seclistc.list(options)
    when 'secrule'
      secrulec = SecRuleClient.new
      secrulec.list(options)
    when 'secapp'
      secappc = SecAppClient.new
      secappc.list(options)
    when 'seciplist'
      seciplistc = SecIPListClient.new
      seciplistc.list(options)
    when 'secassoc'
      secassocc = SecAssocClient.new
      secassocc.list(options)
    when 'ip_reservation', 'ip_association'
      iputilc = IPUtilClient.new
      iputilc.list(options)
    else
      abort('You entered an invalid selection for Function')
    end # end of case
  end
end
