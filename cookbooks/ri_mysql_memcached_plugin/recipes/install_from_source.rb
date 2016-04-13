Chef::Log.info("mysql-memcached : source install dependencies")
package 'cmake' do
	:upgrade
end

package 'bison' do
	:upgrade
end

package 'libncurses5-dev' do
  :upgrade
end

include_recipe "ri_mysql_memcached_plugin::client"



Chef::Log.info("mysql-memcached : download source")
remote_file "#{node[:mysql][:build_dir]}/mysql-#{node[:mysql][:version]}.tar.gz" do
  source "#{node[:rawiron][:backends_url]}/mysql-#{node[:mysql][:version]}.tar.gz"
end

execute "tar xzvf mysql-#{node[:mysql][:version]}.tar.gz" do
  cwd "#{node[:mysql][:build_dir]}"
end


Chef::Log.info("mysql-memcached : create user mysql")
group node[:mysql][:group] do
  system true
end

user node[:mysql][:user] do
  gid node[:mysql][:group]
  shell "/bin/bash"
  home node[:mysql][:datadir]
  system true
end


Chef::Log.info("mysql-memcached : create /var directories")
directory node[:mysql][:datadir] do
  owner node[:mysql][:user]
  group node[:mysql][:group]
  mode 0750
  not_if { ::File.exists?(node[:mysql][:datadir]) }
end

directory node[:mysql][:logdir] do
  owner node[:mysql][:user]
  mode 0755
  action :create
  not_if { ::File.exists?(node[:mysql][:logdir]) }
end

directory node[:mysql][:rundir] do
  owner node[:mysql][:user]
  group node[:mysql][:group]
  mode 0755
  not_if { ::File.exists?(node[:mysql][:rundir]) }
end


Chef::Log.info("mysql-memcached : make install")
execute "make install" do
  cwd "#{node[:mysql][:build_dir]}/mysql-#{node[:mysql][:version]}"
  command <<-EOH
	  cmake . -DWITH_INNODB_MEMCACHED=ON
		make
		make install
  EOH
end

Chef::Log.info("mysql-memcached : install db")
execute "install system catalog" do
  cwd "#{node[:mysql][:source_basedir]}"
  command <<-EOH
		./scripts/mysql_install_db --datadir=#{node[:mysql][:datadir]} --user=#{node[:mysql][:user]}  --no-defaults
		chown -R root .
		chown -R #{node[:mysql][:user]} data
  EOH
end