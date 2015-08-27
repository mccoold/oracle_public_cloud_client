Gem::Specification.new do |s|
  s.name = "oracle_public_cloud_client"
  s.version = "0.0.1"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version= 
  s.authors = ["Daryn McCool"]
  s.date = Date.today.to_s
  s.description = %q{A command line client for the Oracle Public Cloud}
  s.email = %q{mdaryn@hotmail.com}
  s.files += Dir['lib/**/*.rb']
  s.homepage = %q{http://rubygems.org/gems/}
  s.require_paths = ['lib']
  s.license = 'Apache-2.0'
  s.required_ruby_version = '>= 1.8'
  s.add_dependency('OPC', '~> 0.0.1')
  s.executables = ['jaaslist','jaasdelete', 'jaasmanage', 'jaascreate','storagecreate','storagelist', 'storagedelete',
                   'dblist', 'dbcreate', 'dbdelete', 'datagrid', 'dbaasmanage', 'jcsbackuplist', 'jcsbackupconfiglist',
                   'object_upload', 'encrypt', 'decrypt']
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{OPC_client!}
  if s.respond_to? :specification_version then
    s.specification_version = 3
  end
end