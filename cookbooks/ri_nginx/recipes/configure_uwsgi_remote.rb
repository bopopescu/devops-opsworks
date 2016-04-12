ri_configure_uwsgi do
  uwsgi_is :remote
  uwsgi_instances node[:cloud][:uwsgi_instances]
end