Gem::Specification.new do |s|
  s.name = "oracle_public_cloud_client"
  s.version = "0.4.2"
  s.authors = ["Daryn McCool"]
  s.date = Date.today.to_s
  s.description = 'A command line client for the Oracle Public Cloud for PaaS and IaaS'
  s.email = 'mdaryn@hotmail.com'
  s.files += Dir['lib/**/*.rb']
  s.homepage = 'https://github.com/mccoold/oracle_public_cloud_client'
  s.require_paths = ['lib']
  s.license = 'Apache-2.0'
  s.required_ruby_version = '>= 1.8'
  s.add_dependency('OPC', '>= 0.3.3')
  s.add_dependency('json')
  s.executables = ['opclist','opcdelete', 'jcsmanage', 'opccreate', 'objstrg', 'opcnetworkbulkload',
                   'datagrid', 'dbcsmanage', 'encrypt', 'opccompute', 'opcnetworkclient', 
                   'orch_client']
  s.rubygems_version = %q{1.6.2}
  s.summary = 'Oracle_Public_Cloud_Client for PaaS and IaaS'
end