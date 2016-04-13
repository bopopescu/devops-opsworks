include_recipe "ri_python_django::install"


directory node[:django][:sqlite][:data] do
  owner node[:rawiron][:web_user]
  group node[:rawiron][:web_group]
  mode 0750
  action :create
end