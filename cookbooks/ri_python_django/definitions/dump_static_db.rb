define :ri_django_dump_static do
  Chef::Log.info("django : write savepoint for static data")

  if File.exists?("#{node[:django][:app_root]}/scripts/savepoint_staticdata.py")
	  execute "dump static data" do
	    user node[:rawiron][:web_user]
	    group node[:rawiron][:web_group]
	    command "python manage.py runscript savepoint_staticdata"
	    cwd node[:django][:app_root]
	    action :run
	  end
  else
  	Chef::Log.warn("django : could not write a savepoint for static data")
  end

end