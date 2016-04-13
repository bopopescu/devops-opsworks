if node['riak']['package']['enterprise_key'].empty?
  include_recipe "ri_riak::community_package"
else
  include_recipe "ri_riak::enterprise_package"
end

file "#{node['riak']['package']['config_dir']}/app.config" do
  content Eth::Config.new(node['riak']['config'].to_hash).pp
  owner "root"
  mode 0644
  notifies :restart, "service[riak]"
end

file "#{node['riak']['package']['config_dir']}/vm.args" do
  content Eth::Args.new(node['riak']['args'].to_hash).pp
  owner "root"
  mode 0644
  notifies :restart, "service[riak]"
end

service "riak" do
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
end