Chef::Log.info("uwsgi : install from source")


package 'build-essential' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'build-essential'},
    ['ubuntu', 'debian'] => {'default' => 'build-essential'}
  )
  action :upgrade
end

package 'python-dev' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'python-dev'},
    ['ubuntu', 'debian'] => {'default' => 'python-dev'}
  )
  action :upgrade
end

include_recipe "ri_python_django::install_pip"


execute "install-uwsgi" do
  command "pip install #{node[:uwsgi][:download_url]}/uwsgi-#{node[:uwsgi][:version]}.tar.gz"
  action :run
end



Chef::Log.info("uwsgi : creating directory: #{node[:uwsgi][:dir]}")
directory "#{node[:uwsgi][:dir]}/apps-available" do
  owner 'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

directory "#{node[:uwsgi][:dir]}/apps-enabled" do
  owner 'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end