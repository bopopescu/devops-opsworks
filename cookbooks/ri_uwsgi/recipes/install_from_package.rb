Chef::Log.info("UWSGI Installing the packages")

package 'uwsgi' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'uwsgi'},
    ['ubuntu', 'debian'] => {'default' => 'uwsgi'}
  )
  action :upgrade
end

package 'uwsgi-plugin-python' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'uwsgi-plugin-python'},
    ['ubuntu', 'debian'] => {'default' => 'uwsgi-plugin-python'}
  )
  action :upgrade
end


Chef::Log.info("UWSGI start the service")
include_recipe "ri_uwsgi::service"
service "uwsgi" do
  action [ :enable, :start ]
end