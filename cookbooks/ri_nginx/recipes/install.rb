if node[:nginx][:install_from] == :source
	include_recipe "ri_nginx::install_from_source"
end