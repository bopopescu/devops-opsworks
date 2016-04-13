Chef::Log.info("riak : configure")

if node[:cloud][:provider] == "ec2" and node[:cloud][:manager] == "opsworks"
	riak_app_ip = node['ipaddress']
	riak_args_name = "riak@#{node[:cloud][:this_node_fqdn]}"
else
	riak_app_ip = node[:cloud][:this_instance]
	riak_args_name = "riak@#{node[:cloud][:this_instance]}"
end


node.set['riak']['args']['-name'] = riak_args_name
node.set['riak']['config']['riak_api']['pb'] = [["#{riak_app_ip}".to_erl_string, 8087].to_erl_tuple]
node.set['riak']['config']['riak_core']['http'] = [["#{riak_app_ip}".to_erl_string, 8098].to_erl_tuple]

file "#{node['riak']['source']['config_dir']}/app.config" do
  content Eth::Config.new(node['riak']['config'].to_hash).pp
  owner "riak"
  mode 0644
end

file "#{node['riak']['source']['config_dir']}/vm.args" do
  content Eth::Args.new(node['riak']['args'].to_hash).pp
  owner "riak"
  mode 0644
end

service "riak" do
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
end