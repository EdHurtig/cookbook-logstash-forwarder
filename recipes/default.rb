
case node['logstash-forwarder']['install_type']
when 'package'
  include_recipe 'logstash-forwarder::_package'
when 'source'
  include_recipe 'logstash-forwarder::_source'
end

ruby_block 'get log_forward resources' do
  block do
    files = run_context.resource_collection.select { |r| r.is_a?(Chef::Resource::LogForward) }.map { |r| { paths: r.paths, fields: r.fields } }
    node.set['logstash-forwarder']['files'] = files
  end
end

directory node['logstash-forwarder']['config_path'] do
  user node['logstash-forwarder']['user']
  group node['logstash-forwarder']['group']
  mode '0755'
  action :create
end

template "#{node['logstash-forwarder']['config_path']}/logstash-forwarder.conf" do
  source 'forwarder.conf.erb'
  user node['logstash-forwarder']['user']
  group node['logstash-forwarder']['group']
  mode '0640'
  variables(:servers => node['logstash-forwarder']['logstash_servers'])
  notifies :restart, "service[#{node['logstash-forwarder']['service_name']}]"
end
