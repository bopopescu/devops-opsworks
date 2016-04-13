case node[:platform_family]
when "debian"
  include_recipe "python::default"
  package 'libpython2.7'
  
  package 'libapr1'
  package 'libconfuse0'

  ['libganglia1','ganglia-monitor'].each do |package_name|
    remote_file "/tmp/#{package_name}.deb" do
      source "#{node[:ganglia][:package_base_url]}/#{package_name}_#{node[:ganglia][:custom_package_version]}_#{node[:ganglia][:package_arch]}.deb"
      not_if do
        `dpkg-query --show #{package_name} | cut -f 2`.chomp.eql?(node[:ganglia][:package_arch])
      end
    end

    execute "install #{package_name}" do
      command "dpkg -i /tmp/#{package_name}.deb && rm /tmp/#{package_name}.deb"
      only_if { ::File.exists?("/tmp/#{package_name}.deb") }
    end
  end

  remote_file '/tmp/ganglia-monitor-python.deb' do
    source node[:ganglia][:monitor_plugins_package_url]
    not_if { ::File.exists?('/tmp/ganglia-monitor-python.deb') }
  end
  execute 'install ganglia-monitor-python' do
    command 'dpkg -i /tmp/ganglia-monitor-python.deb && rm /tmp/ganglia-monitor-python.deb'
    only_if { ::File.exists?('/tmp/ganglia-monitor-python.deb') }
  end

when "rhel"
  package node[:ganglia][:monitor_package_name]
  package node[:ganglia][:monitor_plugins_package_name]
end

execute 'stop gmond with non-updated configuration' do
  command value_for_platform_family(
    "rhel" => '/etc/init.d/gmond stop',
    "debian" => '/etc/init.d/ganglia-monitor stop'
  )
end

# old broken installations have this empty directory
# new working ones have a symlink
directory "/etc/ganglia/python_modules" do
  action :delete
  not_if { ::File.symlink?("/etc/ganglia/python_modules")}
end

link "/etc/ganglia/python_modules" do
  to value_for_platform_family(
    "debian" => "/usr/lib/ganglia/python_modules",
    "rhel" => "/usr/lib#{RUBY_PLATFORM[/64/]}/ganglia/python_modules"
  )
end

execute "Normalize ganglia plugin permissions" do
  command "chmod 644 /etc/ganglia/python_modules/*"
end

['scripts','conf.d'].each do |dir|
  directory "/etc/ganglia/#{dir}" do
    action :create
    owner "root"
    group "root"
    mode "0755"
  end
end