Chef::Log.info("ganglia : restart")

service "ganglia-monitor" do
  action :restart
end

Chef::Log.info("ganglia : restarted")