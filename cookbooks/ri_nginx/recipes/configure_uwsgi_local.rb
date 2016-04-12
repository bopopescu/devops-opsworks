ri_configure_uwsgi do
  uwsgi_is :local
  uwsgi_instances node[:cloud][:uwsgi_instances]
end