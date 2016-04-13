define :ri_django_reset_user_db do
  Chef::Log.debug("django : init user data: resetdb, syncdb, load")
  
  execute "wipe user data" do
    user node[:rawiron][:web_user]
    group node[:rawiron][:web_group]
    command "python manage.py runscript reset_userdata"
    cwd node[:django][:app_root]
    action :run
  end

  execute "update the schema" do
    user node[:rawiron][:web_user]
    group node[:rawiron][:web_group]
    command "python manage.py runscript sync_userdata"
    cwd node[:django][:app_root]
    action :run
  end

end