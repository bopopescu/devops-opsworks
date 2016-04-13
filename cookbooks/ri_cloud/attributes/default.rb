if node[:cloud].nil?
	Chef::Log.error("cloud : cloud attributes are nil")
else
	require 'json'
	Chef::Log.debug("cloud : cloud attributes are #{node[:cloud].to_json}")
end
Chef::Log.debug("cloud : deploy attributes are #{node[:deploy].to_json}")


if not node[:opsworks].nil? and node[:cloud].nil?
	default[:cloud][:provider] = "ec2"
end
default[:cloud][:manager] = "opsworks"

default[:cloud][:loadbalancers] = false
default[:cloud][:loadbalancer_address] = false
default[:cloud][:nginx_lb_uwsgi] = false
default[:cloud][:haproxy_lb_nginx] = false

default[:cloud][:layers] = {}
default[:cloud][:uwsgi_instances] = nil
default[:cloud][:nginx_instances] = nil
default[:cloud][:memcached_instances] = {}
default[:cloud][:innodb_memcache_instances] = {}
default[:cloud][:memcache_api_instances] = {}
default[:cloud][:mysql_master] = nil
default[:cloud][:riak_instances] = {}
default[:cloud][:riak_nodes] = {}

default[:cloud][:this_node] = 'localhost'
default[:cloud][:this_instance] = "127.0.0.1"

default[:cloud][:my_private_ip] = node['ipaddress']
default[:cloud][:my_public_ip] = ""
default[:cloud][:my_layer] = nil
default[:cloud][:my_cpu] = 1
default[:cloud][:my_user_memory] = 100

default[:cloud][:tools_dir] = "/usr/local"


node.override[:cloud][:this_node] = node['hostname']
Chef::Log.debug("cloud : this node is #{node[:cloud][:this_node]}")

node.set[:cloud][:this_node_fqdn] = "#{node['hostname']}.#{node[:rawiron][:fqdn]}"
Chef::Log.debug("cloud : this node is #{node[:cloud][:this_node_fqdn]}")

if node[:rawiron][:stack][:loadbalancers]
	node.override[:cloud][:loadbalancers] = node[:rawiron][:stack][:loadbalancers]
end
require 'json'
Chef::Log.debug("cloud : loadbalancers are #{node[:cloud][:loadbalancers].to_json}")

node.override[:cloud][:loadbalancer_address] = node[:rawiron][:app_domain]
Chef::Log.debug("cloud : loadbalancer address is #{node[:cloud][:loadbalancer_address]}")


services, service_definitions = 
	Rawiron::Zookeeper::Services.services_requested_with_definitions(node[:rawiron], node[:rawiron][:services])
default[:cloud][:services] = services
default[:cloud][:service_definitions] = service_definitions


Chef::Log.debug("cloud : provider is #{node[:cloud][:provider]}")
Chef::Log.debug("cloud : manager is #{node[:cloud][:manager]}")


include_attribute 'ri_cloud::vagrant'
include_attribute 'ri_cloud::opsworks'


Chef::Log.debug("cloud : this node is in layer #{node[:cloud][:my_layer]}")
require 'json'
Chef::Log.debug("cloud : deploy attributes are #{node[:deploy].to_json}")


require 'json'
Chef::Log.debug("cloud : memcached intances: #{node[:cloud][:memcached_instances].to_json}")
Chef::Log.debug("cloud : memcache api intances: #{node[:cloud][:memcache_api_instances].to_json}")