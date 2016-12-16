require "minitest/autorun"
require "minitest/spec"
require 'opc_client'
require 'opc_client/nimbula/compute_client'
require 'opc_client/utilities'

class TestEcosystem < Minitest::Test
  require 'opc_client'
  
  def test_successfully_connected
    assert @compute.list != nil
  end