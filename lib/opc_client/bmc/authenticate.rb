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
class BmcAuthenticate < BmcClient
  require 'oraclebmc'
  include OracleBMC
  
  def initialize(options)
    @options = options
    security_constructor
  end
  
  def user
    user = @options[:user]
  end
  
  def fingerprint
    fingerprint = @options[:fingerprint]
  end
  
  def tenancy
    tenancy = @options[:tenancy]
  end
  
  def key_file
    key_file = @options[:key_file]
  end
  
  def logger
    logger = @options[:debug]
  end
  
  def region
    region = @options[:region]
  end
  
  def pass_phrase
    pass_phrase = @options[:pass_phrase]
  end
  
  def log_requests
    log_requests = @options[:log_requests]
  end
 
  def verify_certs
    verify_certs = @options[:verify_certs]
  end
  
  attr_writer :options
  
  def security_constructor
    OracleBMC.config = OracleBMC::Config.new
    OracleBMC.config.user = user
    OracleBMC.config.fingerprint = fingerprint
    OracleBMC.config.tenancy = tenancy
    OracleBMC.config.key_file  = key_file
    OracleBMC.config.region  = region
    OracleBMC.config.pass_phrase = pass_phrase
    OracleBMC.config.log_requests  = log_requests
    OracleBMC.config.verify_certs = verify_certs
  end
end
