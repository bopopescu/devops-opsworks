define :ri_deploy_scenarios do
  Chef::Log.info("gatling : deploy scenarios #{params[:app]}")
  
  GATLING_HOME = "/srv/www/gatling/current"
  LOAD_HOME = "/srv/www/loadscenarios/current"

  application = params[:app]
  deploy = params[:deploy_data]
  
  opsworks_deploy_dir do
    cookbook "ri_deploy"
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    cookbook "ri_deploy"
    app application
    deploy_data deploy
  end

  ri_configure_scenarios do
    cookbook "ri_gatling"
    app application
  end

  execute "create sym link from gatling app to scenarios" do
    command "ln -s #{LOAD_HOME}/rawiron #{GATLING_HOME}/user-files/simulations/rawiron"
    not_if { not ::File.exists?("#{GATLING_HOME}/user-files/simulations") }
    not_if { ::File.exists?("#{GATLING_HOME}/user-files/simulations/rawiron") }
    action :run
  end

end