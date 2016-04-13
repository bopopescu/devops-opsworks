ri_after_deploy do
	cookbook "ri_deploy"
	app node[:gatling][:app]
end

include_recipe "ri_gatling::requires"


include_recipe "ulimit"

sysctl_param 'fs.file-max' do
  value node[:gatling][:sysctl][:file_max]
  action :apply
end
user_ulimit node[:gatling][:user] do
  filehandle_limit node[:gatling][:sysctl][:file_max]
end


include_recipe "ri_gatling::configure_nginx"
