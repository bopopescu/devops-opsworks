Chef::Log.debug("ganglia : enable opsworks memcached plugin")

execute "enable memcached stats" do
  command "mv /etc/ganglia/conf.d/memcached.pyconf.disabled /etc/ganglia/conf.d/memcached.pyconf"
  action :run
  only_if { File.exists?("/etc/ganglia/conf.d/memcached.pyconf.disabled") }
end

service "ganglia-monitor" do
  action :restart
end