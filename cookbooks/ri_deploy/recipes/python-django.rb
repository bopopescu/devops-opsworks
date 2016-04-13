node[:deploy].select { |k,v| k == node[:rawiron][:app] }.each do |application, deploy|

  ri_python_django do
  	cookbook "ri_deploy"
    app application  	
    deploy_data deploy
  end

end