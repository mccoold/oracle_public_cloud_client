Gem::Specification.new do |s|
  s.name = "oracle_public_cloud_client"
  s.version = "0.5.0"
  s.authors = ["Daryn McCool"]
  s.date = Date.today.to_s
  s.description = 'A CLI for the Oracle Public Cloud(PaaS and IaaS)'
  s.email = 'mdaryn@hotmail.com'
  s.files += Dir['lib/**/*.rb']
  s.homepage = 'https://github.com/mccoold/oracle_public_cloud_client'
  s.require_paths = ['lib']
  s.license = 'Apache-2.0'
  s.required_ruby_version = '>= 1.8'
  s.add_dependency('OPC', '>= 0.3.4')
  s.add_dependency('json')
  s.executables = ['jcsmanage', 'opc', 'dbcsmanage']        
  s.rubygems_version = %q{1.6.2}
  s.summary = 'Oracle Public Cloud Client for PaaS and IaaS'
end