template "mysql.pyconf in conf.d" do
  path "/etc/ganglia/conf.d/mysql.pyconf"
  source "mysql.pyconf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :password => node[:mysql][:server_root_password],
    :collect => node[:ri_ganglia][:mysql][:collect]
    )
end

service "ganglia-monitor" do
  action :restart
end