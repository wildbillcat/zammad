
sysctl 'vm.max_map_count' do
  value 262144
  action :apply
end

elasticsearch_user 'elasticsearch'
elasticsearch_install 'elasticsearch'
elasticsearch_configure 'elasticsearch'
elasticsearch_service 'elasticsearch'

elasticsearch_plugin 'ingest-attachment' do
  action :install
  options '-b'
  chef_proxy node['zammad']['use_proxy']
  notifies :restart, 'service[elasticsearch]'
end

service 'elasticsearch' do
  action :nothing
end
