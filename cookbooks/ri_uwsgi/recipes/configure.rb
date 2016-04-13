Chef::Log.info("uwsgi : configure")

if node[:cloud][:nginx_lb_uwsgi]
	Chef::Log.info("uwsgi : configure uwsgi remote")
	include_recipe "ri_uwsgi::configure_remote"
else
	Chef::Log.info("uwsgi : configure uwsgi local")
	include_recipe "ri_uwsgi::configure_local"
end