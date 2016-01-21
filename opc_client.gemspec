Gem::Specification.new do |s|
  s.name = "oracle_public_cloud_client"
  s.version = "0.2.2"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version= 
  s.authors = ["Daryn McCool"]
  s.date = Date.today.to_s
  s.description = 'A command line client for the Oracle Public Cloud for PaaS'
  s.email = 'mdaryn@hotmail.com'
  s.files += Dir['lib/**/*.rb']
  s.homepage = 'https://github.com/mccoold/oracle_public_cloud_client'
  s.require_paths = ['lib']
  s.license = 'Apache-2.0'
  s.required_ruby_version = '>= 1.8'
  s.add_dependency('OPC', '~> 0.2.4')
  s.executables = ['opclist','opcdelete', 'jcsmanage', 'opccreate', 'objstrg', 'ntwrk_app_updt', 'network',
                   'datagrid', 'dbcsmanage', 'jcsbkup', 'encrypt', 'computeinst', 'ntwrk_lst', 'blockstorage',
                   'ntwrk_rule_updt','orch_client']
  s.rubygems_version = %q{1.6.2}
  s.summary = 'Oracle_Public_Cloud_Client for PaaS and IaaS'
  if s.respond_to? :specification_version then
    s.specification_version = 3
  end
end