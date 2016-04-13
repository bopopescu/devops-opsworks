define :ri_configure_scenarios do
  Chef::Log.info("gatling : configure scenarios #{params[:app]}")
  
  GATLING_HOME = "/srv/www/gatling/current"
  LOAD_HOME = "/srv/www/loadscenarios/current"

  Chef::Log.info("gatling scenarios : settings")
  cookbook_file "#{LOAD_HOME}/rawiron/#{node[:gatling][:load_settings]}" do
    source "#{node[:gatling][:load_settings]}"
    mode 0644
    owner "root"
    group "root"
    cookbook "ri_gatling"
  end

  template "loadbalancer settings" do
    path "#{LOAD_HOME}/rawiron/LoadbalancerSettings.scala"
    source "LoadbalancerSettings.scala.erb"
    cookbook "ri_gatling"
    owner "#{node[:rawiron][:web_user]}"
    group "#{node[:rawiron][:web_group]}"
    mode 0644
  end

end