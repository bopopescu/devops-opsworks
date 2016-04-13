
template "pyconf in conf.d" do
  path "/etc/ganglia/conf.d/memcached.pyconf"
  source "memcached.pyconf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :port => node[:memcached][:port]
    )
end

# should get this from github
# using a template is bad
template "python module" do
  path "/usr/lib/ganglia/python_modules/memcached.py"
  source "memcached.py.erb"
  owner "root"
  group "root"
  mode 0644
end