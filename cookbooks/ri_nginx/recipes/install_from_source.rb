Chef::Log.info("nginx : install pcre package")
package "libpcre3" do
	action :upgrade
end

package "libpcre3-dev" do
	action :upgrade
end


Chef::Log.info("nginx : download source")
remote_file "#{node[:nginx][:build_dir]}/nginx-#{node[:nginx][:release]}.tar.gz" do
  source "http://nginx.org/download/nginx-#{node[:nginx][:release]}.tar.gz"
end

execute "tar xzvf nginx-#{node[:nginx][:release]}.tar.gz" do
  cwd "#{node[:nginx][:build_dir]}"
end


Chef::Log.info("nginx : make install")
execute "make install" do
  cwd "#{node[:nginx][:build_dir]}/nginx-#{node[:nginx][:release]}"
  command <<-EOH
	  ./configure --with-http_stub_status_module --error-log-path="#{node[:nginx][:log_dir]}/error.log" --http-log-path="#{node[:nginx][:log_dir]}/access.log" --pid-path="#{node[:nginx][:pid_dir]}"
		make
		make install
  EOH
end


Chef::Log.info("nginx : create directories")
directory node[:nginx][:dir] do
  owner 'root'
  group 'root'
  mode '0755'
end

directory node[:nginx][:log_dir] do
  mode 0755
  owner node[:nginx][:user]
  action :create
end

%w{sites-available sites-enabled conf.d}.each do |dir|
  directory File.join(node[:nginx][:dir], dir) do
    owner 'root'
    group 'root'
    mode '0755'
  end
end


Chef::Log.info("nginx : configure")
execute "move config to #{node[:nginx][:dir]}" do
  cwd "#{node[:nginx][:dir]}"
  command <<-EOH
    cp "#{node[:nginx][:source_dir]}/conf/uwsgi_params" .
    cp "#{node[:nginx][:source_dir]}/conf/mime.types" .
  EOH
end

template "proxy_params" do
  path "#{node[:nginx][:dir]}/proxy_params"
  source "proxy_params.erb"
  owner 'root'
  group 'root'
  mode 0644
end


template "init.d script for source install" do
  path "/etc/init.d/nginx"
  source "nginx_source_initd.erb"
  owner 'root'
  group 'root'
  mode 0750
end

template "conf for source install" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner 'root'
  group 'root'
  mode 0644
end