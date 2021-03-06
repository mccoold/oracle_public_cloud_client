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
#
class OpcClient
  require 'opc_client/utilities'
  require 'optparse'
  require 'opc_client/nimbula_client'
  require 'opc_client/validator'
  # the next section is to either enable or disable the oraclebmi gem, that gem has a 
  # dependency on typhoeus which does not install well on windows at all
  # this flag allows users to choose, the default position in this release is false
  enable = {}
  @util = Utilities.new
  @util.config_file_reader(enable)
  enable[:bmcenable] = 'false' unless enable[:bmcenable]
  if enable[:bmcenable] == 'true'
    require 'opc_client/bmc_client'
  end
end