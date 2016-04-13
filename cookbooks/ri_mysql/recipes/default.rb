template "/etc/mysql/conf.d/rawiron.cnf" do
  source "rawiron.cnf.erb"
  owner "mysql"
  group "mysql"
  mode 0640
end

include_recipe "mysql::service"

service "mysql" do
  action :restart
end