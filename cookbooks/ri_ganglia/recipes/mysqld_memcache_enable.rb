package 'python-mysqldb' do
  action :upgrade
end

template "mysql.pyconf in conf.d" do
  path "/etc/ganglia/conf.d/mysql.pyconf"
  source "mysql.pyconf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :password => "",
    :collect => node[:ri_ganglia][:mysql][:collect]
    )
end

# mysql 5.6
cookbook_file "/usr/lib/ganglia/python_modules/mysql.py" do
  source "mysql.py"
  mode 0644
  owner "root"
  group "root"
end

cookbook_file "/usr/lib/ganglia/python_modules/DBUtil.py" do
  source "DBUtil.py"
  mode 0644
  owner "root"
  group "root"
end

service "ganglia-monitor" do
  action :restart
end