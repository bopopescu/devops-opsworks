Chef::Log.info("haproxy : configure")


if node[:cloud][:haproxy_lb_nginx]

	instances = node[:cloud][:nginx_instances]
	require 'json'
	Chef::Log.debug("haproxy : nginx instances are #{instances.to_json}")

	members = []
	instances.each do |instance_name, instance|
		members.append {
		  "hostname" => instance[:hostname],
		  "ipaddress" => instance[:private_ip],
		  "port" => 80,
		  "ssl_port" => 80
		}
	end

	require 'json'
	Chef::Log.debug("haproxy : members are #{members.to_json}")	
	node.override['haproxy']['members']


	member_port = node['haproxy']['member_port']
	pool = []
	pool << "option httpchk #{node['haproxy']['httpchk']}" if node['haproxy']['httpchk']
	servers = node['haproxy']['members'].map do |member|
		"#{member['hostname']} #{member['ipaddress']}:#{member['port'] || member_port} weight #{member['weight'] || member_weight} maxconn #{member['max_connections'] || member_max_conn} check"
	end

	haproxy_lb 'servers-http' do
		type 'backend'
		servers servers
		params pool
	end

end