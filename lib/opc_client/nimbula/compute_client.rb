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
class ComputeClient < NimbulaClient
  # Request Handler is for command line calls
  # handles functions then hands off to an option_parse method for the action
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse = InputParse.new(args)
    @options = inputparse.compute('compute')
    @options[:function] = @argsfunction if @argsfunction
    @util = Utilities.new
    attrcheck = { 'Action'  => @options[:action],
                  'Service' => @options[:function] }
    @validate = Validator.new
    @validate.attrvalidate(@options, attrcheck)
    case @options[:function].downcase
    when 'instance', 'inst_snapshot'
      option_parse
    when 'imagelist'
      option_parse_imagelist
    when 'machineimage'
      option_parse_machineimage
    else
      abort('you did not select a valid Service, options are block_storage, snap_storage,
            volume_snapshot, instance, inst_snapshot')
    end
  end
  
  # parses actions for machine images
  def option_parse_machineimage
    case @options[:action].downcase
    when 'list', 'details'
      machineimage_list
    when 'delete'
      delete
    when 'create'
      machineimage_create
    else
      abort('you did not enter a correct value for action: list, details, create, delete')
    end
  end
  
  # parses action for image list 
  def option_parse_imagelist
    case @options[:action].downcase
    when 'list', 'details'
      image_list
    when 'delete'
      delete
    when 'create'
      image_create
    else
      abort('you did not enter a correct value for action: list, details, create, delete')
    end
  end

  # option parse for instances and snapshots
  def option_parse
    case @options[:action].downcase
    when 'list', 'details'
      list
    when 'delete'
      delete
    when 'shape_list'
      shape_list
    when 'list_ip'
      list_ip
    when 'create'
      abort('create only for snapshot') unless @options[:function].downcase == 'inst_snapshot'
      create_snap
    else
      abort('You entered an invalid selection for Action, the options are : machineimage_list, machineimage_create,
       list_ip, list, details, delete')
    end
  end

  attr_writer :options, :util, :validate, :argsfunction

  # list method for instances and inst_snapshot
  def list # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instanceconfig = Instance.new(@options)
    instanceconfig.function = '/snapshot' if @options[:function].downcase == 'inst_snapshot'
    instanceconfig = instanceconfig.list
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end
  
  # list method of image lists
  def image_list # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instanceconfig = ImageList.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instanceconfig = instanceconfig.list(@options[:container])
    # error checking response
    @util.response_handler(instanceconfig)
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end 
  
  # create method for machine images
  def image_create # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Create JSON'       => @options[:create_json]
    }
    @validate.attrvalidate(@options, attrcheck)
    file = File.read(@options[:create_json])
    create_data = JSON.parse(file)
    instanceconfig = ImageList.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instanceconfig = instanceconfig.create(create_data)
    # error checking response
    @util.response_handler(instanceconfig)
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end

  # list method for machine images
  def machineimage_list # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instanceconfig = MachineImage.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instanceconfig = instanceconfig.list(@options[:container], @options[:action])
    # error checking response
    @util.response_handler(instanceconfig)
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end

  # create method for machine images
  def machineimage_create # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Create JSON'     => @options[:create_json]
    }
    @validate.attrvalidate(@options, attrcheck)
    file = File.read(@options[:create_json])
    create_data = JSON.parse(file)
    instanceconfig = MachineImage.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instanceconfig = instanceconfig.create(create_data)
    @util.response_handler(instanceconfig)
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end

  # delete method for instances and instance snapshots
  def delete # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instance = Instance.new(@options)
    instancedelete.function = '/snapshot' if @options[:function].downcase == 'inst_snapshot'
    instancedelete = instance.delete(@options[:container])
    # error checking response
    @util.response_handler(instancedelete)
    puts 'deleted' if instancedelete.code == '204'
  end

  # list method for shapes
  def shape_list # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instanceconfig = Shape.new(@options[:id_domain], @options[:user_name], @options[:passwd])
    instanceconfig = instanceconfig.list(@options[:rest_endpoint], @options[:container])
    @util.response_handler(instanceconfig)
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end

  # method to find the external IP for instances
  def list_ip # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instanceconfig = Instance.new(@options)
    instanceconfig = instanceconfig.list_ip(@options[:container])
    return 'Internal_IP=' + instanceconfig[0], 'ExternalIP=' + instanceconfig[1]
  end

  # creates new snap shot of an instance
  def create_snap # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instance = Instance.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instance.function = '/snapshot/' if @options[:function].downcase == 'inst_snapshot'
    instance.machine_image = @options[:inst] if @options[:inst]
    instancesnap = instance.create_snap
    # error checking response
    @util.response_handler(instancesnap)
    return JSON.pretty_generate(JSON.parse(instancesnap.body))
  end
end
