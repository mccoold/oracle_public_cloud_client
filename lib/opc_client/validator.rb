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
class Validator < NimbulaClient
  def attrvalidate(options, attrcheck)  # rubocop:disable Metrics/AbcSize
    attrcheck['id_domain'] = options[:id_domain]
    attrcheck['password']  = options[:passwd]
    attrcheck['user_name']  = options[:user_name]
    validate(options, attrcheck)
  end
  
  def validate(options, attrcheck)
    if !attrcheck.nil?
          attrcheck.each do |key, attr|
            next unless attr.nil?
            abort(key + ' is null, it can not be empty. use -h flag for list of arguements')
          end
    end
  end
end
