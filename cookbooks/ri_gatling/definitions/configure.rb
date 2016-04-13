define :ri_configure_gatling do
  Chef::Log.info("gatling : configure application #{params[:app]}")
  
  GATLING_HOME = "#{node[:gatling][:deploy_app_root]}/current"
  LOAD_HOME = "#{node[:gatling][:deploy_scenarios]}/current"

  template "gatling.sh with vm options" do
    path "#{node[:gatling][:app_root]}/bin/gatling.sh"
    source "gatling.sh.erb"
    cookbook "ri_gatling"
    owner "#{node[:rawiron][:web_user]}"
    group "#{node[:rawiron][:web_group]}"
    mode 0755
  end

end