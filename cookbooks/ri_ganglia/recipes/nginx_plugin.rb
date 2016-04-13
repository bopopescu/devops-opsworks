if not File.exists?("/etc/ganglia/conf.d/nginx.pyconf")
  template "pyconf in conf.d" do
    path "/etc/ganglia/conf.d/nginx.pyconf"
    source "nginx.pyconf.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :url => "http://nginx_status",
      :binary => "/usr/sbin/nginx"
      )
  end

  cookbook_file "/usr/lib/ganglia/python_modules/nginx.py" do
    source "nginx.py"
    mode 0644
    owner "root"
    group "root"
  end

  service "ganglia-monitor" do
    action :restart
  end
end