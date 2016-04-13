Chef::Log.info("django : configure")

app_domain = node[:cloud][:loadbalancer_address]
services = node[:cloud][:services] 
service_definitions = node[:cloud][:service_definitions]

memcached_instances = node[:cloud][:memcached_instances]
innodb_memcache_instances = node[:cloud][:innodb_memcache_instances]
riak_instances = node[:cloud][:riak_instances]
mysql_master = node[:cloud][:mysql_master]
memcache_api_instances = node[:cloud][:memcache_api_instances]


sqlite_flag = false
if node[:rawiron][:stack][:db_servers][:layer] == "app" and 
	 node[:rawiron][:stack][:db_servers][:engine] == "sqlite"
	sqlite_flag = true
	Chef::Log.debug("django : enable sqlite")
end

ri_django_configure do
	domain app_domain
	mysql mysql_master
	sqlite sqlite_flag
	memcached memcache_api_instances
	riak riak_instances
	services services
	service_definitions service_definitions
end