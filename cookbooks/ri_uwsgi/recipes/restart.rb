service "uwsgi-#{node[:uwsgi][:app]}" do
  supports :status => false, :restart => true, :reload => true, :stop => true
end

service "uwsgi-#{node[:uwsgi][:app]}" do
  action :restart
end