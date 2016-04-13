def app_deployed?
	File.exists?(node[:django][:app_root])
end


if app_deployed?
	include_recipe 'ri_python_django::configure_app'
else
	Chef::Log.info("django : no app available for configure")
end