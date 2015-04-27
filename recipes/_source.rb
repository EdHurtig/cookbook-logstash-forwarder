#
# Cookbook Name:: logstash-forwarder
# Recipe:: _source
# Author:: Eddie Hurtig <eddie.hurtig@evertrue.com>
#
# Copyright (c) 2015, Parallels IP Holdings GmbH
#

include_recipe 'golang'

directory node['logstash-forwarder']['install_dir'] do
  user node['logstash-forwarder']['user']
  group node['logstash-forwarder']['group']
  mode 0700
end

git node['logstash-forwarder']['install_dir'] do
  repository node['logstash-forwarder']['git_repo']
  revision node['logstash-forwarder']['git_ref']
  action :checkout
  notifies :run, 'execute[build-logstash-forwarder]'
end

execute 'build-logstash-forwarder' do
  cwd node['logstash-forwarder']['install_dir']
  command '/usr/local/go/bin/go build'
  action :nothing
  user node['logstash-forwarder']['user']
  group node['logstash-forwarder']['group']
end

template "/etc/init.d/#{node['logstash-forwarder']['service_name']}" do
  source 'logstash-forwarder-init.erb'
  owner 'root'
  group 'root'
  mode 0755
end

service node['logstash-forwarder']['service_name'] do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
