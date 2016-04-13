node[:deploy].select { |k,v| k == node[:gatling][:app] }.each do |application, deploy|

  ri_deploy_gatling do
    cookbook "ri_gatling"
    app application
    deploy_data deploy
  end

end