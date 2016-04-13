include_recipe "ri_riak::riak_default"
 

template "riak init.d script" do
  path "/etc/init.d/riak"
  source "riak.init.d.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :user => node['riak']['user'],
    :app_name => "",
    :app_ini => ""
  )
  not_if {::File.exists?("/etc/init.d/riak")}
end


include_recipe "ri_riak::riak_configure"

include_recipe "ri_riak::configure_storage"