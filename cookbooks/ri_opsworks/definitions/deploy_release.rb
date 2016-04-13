define :deploy_release do
	Chef::Log.debug("deploy release #{params[:app]}")
	# must copy into local variables
	# otherwise the nested calls receive empty params
	# need a value not a reference ??.. probably
	application = params[:app]
	deploy = params[:deploy_data]

	ri_python_django do
		cookbook "ri_deploy"
		deploy_data deploy
		app application
	end

	include_recipe "ri_python_django::configure"

	Chef::Log.debug("done deploy release #{params[:app]}")
end