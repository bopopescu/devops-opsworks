if node[:mysql][:install_from] == :source
	include_recipe "ri_mysql_memcached_plugin::install_from_source"
end