Chef::Log.debug("uwsgi: configure app.ini")

template "wsgi_django.ini" do
  path "/etc/uwsgi/apps-available/#{node[:uwsgi][:app]}.ini"
  source "wsgi_django.ini.erb"
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :app_user => node[:uwsgi][:user],
    :app_group => node[:uwsgi][:group],
    :app => node[:uwsgi][:app],
    :app_dir => node[:uwsgi][:app_dir],
    :stats_path => node[:uwsgi][:stats_path],
    :socket => "#{node[:uwsgi][:host]}:#{node[:uwsgi][:port]}"
  )
  #notifies :restart, resources(:service => 'uwsgi'), :immediately
end

execute "create sym link from apps-available to apps-enabled" do
  command "ln -s /etc/uwsgi/apps-available/#{node[:uwsgi][:app]}.ini /etc/uwsgi/apps-enabled/#{node[:uwsgi][:app]}.ini"
  action :run
  not_if {FileTest.exists?("/etc/uwsgi/apps-enabled/#{node[:uwsgi][:app]}.ini")}
end