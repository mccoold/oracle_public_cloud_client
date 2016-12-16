require "minitest/autorun"
require "minitest/spec"
require 'opc_client'
require 'opc_client/nimbula/compute_client'
require 'opc_client/utilities'

class TestInstance < Minitest::Test
  require 'opc_client'
  def setup
    @orch = OrchClient.new
    @util = Utilities.new
    @validate = Validator.new
    @opts = {}
    @opts[:passwd] = 'veLvet@4Chink'
    @opts[:container] = '/Compute-gse00002056/'
    @opts[:function] = 'instance'
    @opts[:action] = 'list'
    @options = Utilities.new
    @options = @options.config_file_reader(@opts)
    @orch.options = @options
    @orch.util = @util
    orch = Orchestration.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    @orch.orch = orch
  end
  
  def test_successfully_connected
    assert @orch.list != nil
  end
  
  def test_instance_list
    test = JSON.parse(@orch.list)
    assert_equal ["/Compute-gse00002056/cloud.admin/"], test['result']
  end
  
  def test_inst_snapshot_list
    @options[:function] = 'inst_snapshot'
    @orch.options = @options
    test = JSON.parse(@orch.list)
    assert_equal ["/Compute-gse00002056/cloud.admin/"], test['result']
  end
end
