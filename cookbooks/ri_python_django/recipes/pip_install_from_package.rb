Chef::Log.info("python : install pip from package")


package 'python-pip' do
  package_name value_for_platform(
    ['centos','redhat','fedora','amazon'] => {'default' => 'python-pip'},
    ['ubuntu', 'debian'] => {'default' => 'python-pip'}
  )
  action :upgrade
end