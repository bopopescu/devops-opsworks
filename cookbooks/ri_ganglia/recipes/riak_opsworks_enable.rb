Chef::Log.info("ganglia : enable riak")

template "riak.pyconf in conf.d" do
  path "/etc/ganglia/conf.d/riak.pyconf"
  source "riak.pyconf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :private_ip => node['ipaddress']
    )
	not_if {::File.exists?("/etc/ganglia/conf.d/riak.pyconf")}
end

service "ganglia-monitor" do
  action :restart
end

Chef::Log.info("ganglia : riak enabled")