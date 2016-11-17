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
class NimbulaClient < OpcClient
  require 'OPC'
  require 'opc_client/nimbula/jcs_client'
  require 'opc_client/nimbula/iputil_client'
  require 'opc_client/nimbula/seclist_client'
  require 'opc_client/nimbula/seciplist_client'
  require 'opc_client/nimbula/secassoc_client'
  require 'opc_client/nimbula/paas_client'
  require 'opc_client/nimbula/object_storage_client'  
  require 'opc_client/nimbula/datagrid_client'
  require 'opc_client/nimbula/network_client'
  require 'opc_client/nimbula/dbcs_client'
  require 'opc_client/nimbula/orch_client'
  require 'opc_client/nimbula/backupmgr_client'
  require 'opc_client/nimbula/inputparse'
  require 'opc_client/nimbula/compute_client'
  require 'opc_client/nimbula/secrule_client'
  require 'opc_client/nimbula/paas_helpers'
  require 'opc_client/nimbula/secapp_client'
  require 'opc_client/nimbula/block_storage_client'
  require 'opc_client/nimbula/sshkey_client'
  require 'opc_client/nimbula/ipnetwork_client'
end
 