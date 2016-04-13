define :ri_django_reset_static_db do
  Chef::Log.info("django : init static data with resetdb, load")

  ri_django_dump_static do
    cookbook "ri_python_django"
  end

  execute "wipe static data" do
    user node[:rawiron][:web_user]
    group node[:rawiron][:web_group]
    command "python manage.py runscript reset_staticdata"
    cwd node[:django][:app_root]
    action :run
  end

  execute "load static data" do 
    user node[:rawiron][:web_user]
    group node[:rawiron][:web_group]
    command "python manage.py runscript load_staticdata"
    cwd node[:django][:app_root]
    action :run
  end

end