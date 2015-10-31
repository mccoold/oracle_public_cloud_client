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
  require 'OPC'
  require 'opc_client/jcs_client'
  require 'opc_client/list'
  require 'opc_client/iputil_client'
  require 'opc_client/network'
  require 'opc_client/seclist_client'
  require 'opc_client/seciplist_client'
  require 'opc_client/secassoc_client'
  require 'opc_client/paas_client'
  require 'opc_client/object_storage_client'
  require 'optparse'
  require 'opc_client/datagrid_client'
  require 'opc_client/networklist'
  require 'opc_client/dbcs_client'
  require 'opc_client/backupmgr_client'
  require 'opc_client/inputparse'
  require 'opc_client/validator'
  require 'opc_client/util'
  require 'opc_client/compute_client'
  require 'opc_client/secrule_client'
  require 'opc_client/secapp_client'
  require 'opc_client/block_storage_client'
 end
 