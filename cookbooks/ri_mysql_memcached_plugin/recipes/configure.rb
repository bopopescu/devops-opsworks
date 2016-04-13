Chef::Log.info("mysql-memcached : configure")

include_recipe "ri_mysql_memcached_plugin::service"


Chef::Log.info("mysql-memcached : create /etc directories")
directory node[:mysql][:conf_dir] do
  owner node[:mysql][:user]
  group node[:mysql][:group]
  mode 0750
end

directory node[:mysql][:confd_dir] do
  owner node[:mysql][:user]
  group node[:mysql][:group]
  mode 0750
  action :create
end


ruby_block "Rename existing /etc/mysql/my.cnf" do
  block do
    ::File.rename("/etc/mysql/my.cnf", "/etc/mysql/my.cnf.bak")
  end
  only_if { ::File.exists?("/etc/mysql/my.cnf") }
end


if node[:mysql][:install_from] == :source
  my_cnf_path = "/usr/local/mysql/my.cnf"
=begin
elsif node[:mysql][:install_from] == :source and
	 node[:mysql][:release] == "5" and node[:mysql][:major] == "6"
		my_cnf_path = "/usr/local/mysql/my.cnf"
=end
else
  my_cnf_path = "/etc/mysql/my.cnf"  
end
Chef::Log.debug("mysql-memcached : conf file is #{my_cnf_path}")


template 'create my.cnf' do
  path my_cnf_path
  source 'my.cnf.erb'
  backup false
  owner 'root'
  group 'root'
  mode 0644
end


service 'mysql' do
	action :restart
end