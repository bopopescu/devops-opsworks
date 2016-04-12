Chef::Log.info("nginx : configure uwsgi")

if node[:cloud][:nginx_lb_uwsgi] and node[:cloud][:my_layer] == "nginx"
	Chef::Log.info("nginx : configure uwsgi remote")
	include_recipe "ri_nginx::configure_uwsgi_remote"
else
	Chef::Log.info("nginx : configure uwsgi local")
	include_recipe "ri_nginx::configure_uwsgi_local"
end