#
# Cookbook Name:: logstash-forwarder
# Recipe:: _package
# Author:: Pavel Yudin <pyudin@parallels.com>
#
# Copyright (c) 2015, Parallels IP Holdings GmbH
#
#

remote_file package_path do
  owner node['logstash-forwarder']['user']
  group node['logstash-forwarder']['group']
  mode '0644'
  source package_url
end

if platform_family?('ubuntu', 'debian')
  dpkg_package node['logstash-forwarder']['package_name'] do
    source package_path
    action :install
  end
else
  package node['logstash-forwarder']['package_name'] do
    source package_path
    action :install
  end
end

service node['logstash-forwarder']['service_name'] do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end
