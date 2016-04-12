Chef::Log.info("nginx : default recipe")


include_recipe "ulimit"

sysctl_param 'fs.file-max' do
  value node[:nginx][:sysctl][:file_max]
  action :apply
end
user_ulimit node[:nginx][:user] do
  filehandle_limit node[:nginx][:sysctl][:file_max]
end


include_recipe "ri_nginx::install"


Chef::Log.info("nginx : disable default site")
file "#{node[:nginx][:dir]}/sites-enabled/default" do
  action :delete
  only_if do
    node[:nginx][:disable_default_site] and File.exists?("#{node[:nginx][:dir]}/sites-enabled/default")
  end
end

include_recipe "ri_nginx::proxy"


include_recipe "nginx::service"

service "nginx" do
  action [ :enable, :start ]
end