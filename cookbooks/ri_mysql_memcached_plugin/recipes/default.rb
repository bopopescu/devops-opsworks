include_recipe "ri_mysql_memcached_plugin::install"


execute "copy init.d script" do
  command "cp #{node[:mysql][:source_basedir]}/support-files/mysql.server /etc/init.d/mysql"
  action :run
end

service 'mysql' do
  supports :restart => true, :stop => true, :start => true
  action :enable
end

include_recipe "ri_mysql_memcached_plugin::configure"

include_recipe "ri_mysql_memcached_plugin::memcached_plugin"


=begin
Chef::Log.info("mysql-memcached : root password")
execute 'assign root password' do
  command "/usr/bin/mysqladmin -u root password \"#{node[:mysql][:server_root_password]}\""
  action :run
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end
=end

Chef::Log.info("mysql-memcached : tools")
package "libmemcached-tools" do
  action :upgrade
end