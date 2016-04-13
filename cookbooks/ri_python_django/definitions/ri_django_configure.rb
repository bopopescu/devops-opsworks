define :ri_django_configure do
  Chef::Log.info("django : configure")
  
  domain = params[:domain]
  memcached_nodes = params[:memcached]
  riak_nodes = params[:riak]
  mysql_master = params[:mysql]
  sqlite = params[:sqlite]
  services = params[:services]
  service_definitions = params[:service_definitions]

  settings_module = (node[:django][:settings] rescue "local_settings")


  template "local_settings.py" do
    path "#{node[:django][:app_dir]}/local_settings.py"
    source "#{settings_module}.py.erb"
    cookbook "ri_python_django"
    owner node[:rawiron][:web_user]
    group node[:rawiron][:web_group]
    mode 0644
    variables(
      :domain => domain,
      :stack => node[:rawiron][:stack],
      :services_requested => services,
      :service_definition => service_definitions,
      :databases => (node[:django][:databases]),
      :memcached => memcached_nodes,
      :riak => riak_nodes,
      :mysql => mysql_master,
      :sqlite => sqlite
    )
  end

end