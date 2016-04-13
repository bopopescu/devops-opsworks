Chef::Log.info("django : runserver")

execute "start server" do
  user node[:rawiron][:web_user]
  group node[:rawiron][:web_group]
  command "python manage.py runserver 0.0.0.0:8000 &"
  cwd node[:django][:app_root]
  action :run
end