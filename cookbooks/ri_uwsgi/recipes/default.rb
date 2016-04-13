include_recipe "ri_uwsgi::requires"

include_recipe "ri_uwsgi::install"


Chef::Log.info("uwsgi : tools")
execute "install-uwsgitop" do
  command "pip install uwsgitop"
  action :run
end


Chef::Log.info("uwsgi: create init.d scripts")
directory node[:uwsgi][:log_dir] do
  owner node[:uwsgi][:user]
  group node[:uwsgi][:group]
  mode 0755
  action :create
end

template "uwsgi init.d script" do
  path "/etc/init.d/uwsgi-#{node[:uwsgi][:app]}"
  source "uwsgi_newrelic.init.d.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :app_name => node[:uwsgi][:app],
    :app_ini => node[:uwsgi][:app_ini]
  )
end

template "upstart script" do
  path "#{node[:uwsgi][:dir]}/upstart"
  source "upstart.erb"
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :app_name => node[:uwsgi][:app],
    :app_ini => node[:uwsgi][:app_ini]
  )
  #notifies :restart, resources(:service => 'uwsgi'), :immediately
end