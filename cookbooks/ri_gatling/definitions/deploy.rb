define :ri_deploy_gatling do
  Chef::Log.info("gatling : deploy application #{params[:app]}")

  application = params[:app]
  deploy = params[:deploy_data]

  ri_deploy_common do
    cookbook "ri_deploy"
    app application
    deploy_data deploy
  end


  GATLING_HOME = "#{node[:gatling][:deploy_app_root]}/current"
  LOAD_HOME = "#{node[:gatling][:deploy_scenarios]}/current"

  ri_configure_gatling do
    cookbook "ri_gatling"
    app application
  end

  execute "create sym link from gatling app to scenarios" do
    command "ln -s #{LOAD_HOME}/simulations/ #{GATLING_HOME}/user-files/simulations/rawiron"
    only_if { ::File.exists?("#{LOAD_HOME}/simulations") }
    action :run
  end

end