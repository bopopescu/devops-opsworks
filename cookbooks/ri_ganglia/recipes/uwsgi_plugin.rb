Chef::Log.info("ganglia : install uwsgi python plugin")

if not File.exists?("/etc/ganglia/conf.d/uwsgi.pyconf")
  template "pyconf in conf.d" do
    path "/etc/ganglia/conf.d/uwsgi.pyconf"
    source "uwsgi.pyconf.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :socket => "/var/log/uwsgi/sstat.sock",
      :refresh_rate => 5
      )
  end

  cookbook_file "/usr/lib/ganglia/python_modules/uwsgi.py" do
    source "uwsgi.py"
    mode 0644
    owner "root"
    group "root"
  end

  service "ganglia-monitor" do
    action :restart
  end
end