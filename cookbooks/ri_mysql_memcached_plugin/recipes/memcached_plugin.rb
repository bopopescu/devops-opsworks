Chef::Log.info("mysql-memcached : enable plugin")

execute "install memcached plugin" do
  cwd "#{node[:mysql][:source_basedir]}"
  command <<-EOH
		mysql -u root < ./share/innodb_memcached_config.sql
		mysql -u root -e 'install plugin daemon_memcached soname "libmemcached.so";'
  EOH
end


Chef::Log.info("mysql-memcached : create default table")

cookbook_file "#{node[:mysql][:source_basedir]}/share/ri_create_mc_default.sql" do
  source "ri_create_mc_default.sql"
  mode 0644
  owner "mysql"
  group "mysql"
end

execute "install default table" do
  cwd "#{node[:mysql][:source_basedir]}"
  command <<-EOH
		mysql -u root < ./share/ri_create_mc_default.sql
  EOH
end


service 'mysql' do
	action :restart
end