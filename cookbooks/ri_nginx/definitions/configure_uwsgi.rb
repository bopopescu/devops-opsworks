define :ri_configure_uwsgi do
	Chef::Log.info("nginx : configure uwsgi")

	uwsgi_location = params[:uwsgi_is]
	instances = params[:uwsgi_instances]
	require 'json'
  	Chef::Log.debug("uwsgi instances: #{instances.to_json}")


	template "#{node[:rawiron][:app]}_nginx.conf" do
	  path "#{node[:nginx][:dir]}/sites-available/#{node[:rawiron][:app]}.conf"
	  source "nginx_uwsgi.erb"
	  owner 'root'
	  group 'root'
	  mode 0644
	  variables(
	    :app => node[:rawiron][:app],
	    :app_domain => node[:rawiron][:app_domain],
	    :app_dir => node[:rawiron][:nginx_dir],
	    :uwsgi_location => uwsgi_location,
	    :uwsgi_servers => instances
	  )
	end

	execute "create sym link from apps-available to apps-enabled" do
	  command "ln -s #{node[:nginx][:dir]}/sites-available/#{node[:rawiron][:app]}.conf #{node[:nginx][:dir]}/sites-enabled/#{node[:rawiron][:app]}.conf"
	  action :run
	  not_if {FileTest.exists?("#{node[:nginx][:dir]}/sites-enabled/#{node[:rawiron][:app]}.conf")}
	end

end