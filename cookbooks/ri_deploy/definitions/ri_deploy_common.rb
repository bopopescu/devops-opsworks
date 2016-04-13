define :ri_deploy_common do
  Chef::Log.info("deploy : common")

  application = params[:app]
  deploy = params[:deploy_data]


  include_recipe "ri_scm_helper::requires"

  opsworks_deploy_user do
    deploy_data deploy
  end

  opsworks_deploy_dir do
    cookbook "ri_deploy"
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  ri_deploy do
    cookbook "ri_deploy"
    app application
    deploy_data deploy
  end

  ri_after_deploy do
    cookbook "ri_deploy"
    app application
  end

end