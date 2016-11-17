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
class BmcClient < OpcClient
  require 'oraclebmc'
  require 'yaml'
  require 'opc_client/bmc/instance_client'
  require 'opc_client/bmc/bmcinputparser'
  require 'opc_client/bmc/authenticate'
  require 'opc_client/bmc/attr_finder'
  require 'opc_client/bmc/vcn_client'
  require 'opc_client/bmc/identity_client'
  require 'opc_client/bmc/bmc_blockstorage_client.rb'
end