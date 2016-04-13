Chef::Log.info("localshop : default")


include_recipe "localshop::default"

cookbook_file "#{node['localshop']['dir']}/current/initial_data.json" do
  source "initial_data.json"
  mode 0644
  owner node['localshop']['user']
  group node['localshop']['group']
end

Chef::Log.info("localshop : load fixtures")
execute "load fixtures" do
  user node['localshop']['user']
  cwd "#{node['localshop']['dir']}"
  command <<-EOH
		. ./shared/env/bin/activate
		LOCALSHOP_HOME="#{node['localshop']['dir']}/shared" ./current/manage.py loaddata ./current/initial_data.json
  EOH
end


if node['localshop']['ebs']
  include_recipe "ri_localshop::ebs"
end
