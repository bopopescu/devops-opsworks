Chef::Log.info("nginx : create dir for proxy cache")
directory "#{node[:nginx][:web_root]}" do
  owner node[:nginx][:user]
  group node[:nginx][:group]
  mode 0755
  action :create
  not_if {FileTest.directory?("#{node[:nginx][:web_root]}")}
end

directory "#{node[:nginx][:web_root]}/cache" do
  owner node[:nginx][:user]
  group node[:nginx][:group]
  mode 0755
  action :create
  not_if {FileTest.directory?("#{node[:nginx][:web_root]}/cache")}
end

Chef::Log.info("nginx : create dir for proxy cache temp")
directory "#{node[:nginx][:web_root]}/cache/tmp" do
  owner node[:nginx][:user]
  group node[:nginx][:group]
  mode 0755
  action :create
  not_if {FileTest.directory?("#{node[:nginx][:web_root]}/cache/tmp")}
end


Chef::Log.info("nginx : configure proxy")
template "proxy.conf" do
  path "#{node[:nginx][:dir]}/conf.d/proxy.conf"
  source "proxy.conf.erb"
  owner 'root'
  group 'root'
  mode 0644
end