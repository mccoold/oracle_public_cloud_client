Gem::Specification.new do |s|
  s.name = "oracle_public_cloud_client"
  s.version = "0.1.1"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version= 
  s.authors = ["Daryn McCool"]
  s.date = Date.today.to_s
  s.description = %q{A command line client for the Oracle Public Cloud}
  s.email = %q{mdaryn@hotmail.com}
  s.files += Dir['lib/**/*.rb']
  s.homepage = %q{https://github.com/mccoold/oracle_public_cloud_client}
  s.require_paths = ['lib']
  s.license = 'Apache-2.0'
  s.required_ruby_version = '>= 1.8'
  s.add_dependency('OPC', '~> 0.2.1')
  s.executables = ['opclist','opcdelete', 'jcsmanage', 'opccreate','storagecreate','objstrglst', 'objstrgdel',
                   'datagrid', 'dbcsmanage', 'jcsbkuplst', 'jcsbkupcfglst', 'object_upload', 'encrypt', 'computeinstlist',
                   'ntwrk_app_lst', 'ntwrk_rule_lst', 'ntwrk_rule_updt', 'ntwrk_app_updt', 'blockstoragelist', 'network',
                   'blockstorageupdate', 'ntwrk_seclist_list']
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{OPC_client!}
  if s.respond_to? :specification_version then
    s.specification_version = 3
  end
end