default[:gatling][:app] = "gatling"
default[:gatling][:app_root] = node[:rawiron][:web_root] + "/#{node[:gatling][:app]}"
default[:gatling][:deploy_app_root] = "/srv/www" + "/#{node[:gatling][:app]}"
default[:gatling][:deploy_scenarios] = "/srv/www" + "/loadscenarios"
default[:gatling][:load_settings] = "LoadSettings.scala"

default[:gatling][:jvm][:xms] = (node[:cloud][:my_user_memory] * 0.7).to_int
default[:gatling][:jvm][:xmx] = (node[:cloud][:my_user_memory] * 0.7).to_int

if node[:cloud][:loadbalancers] and node[:cloud][:loadbalancers].key?("elb")
	default[:gatling][:jvm][:options] = "-Dsun.net.inetaddr.ttl=0"
else
	default[:gatling][:jvm][:options] = ""
end

if node[:rawiron].key?(:gatling) and node[:rawiron][:gatling].key?(:webservers)
	default[:gatling][:webservers] = node[:rawiron][:gatling][:webservers]
else
	default[:gatling][:webservers] = []
end

default[:gatling][:sysctl][:file_max] = 65536
# should run this as www-data
default[:gatling][:user] = "root"

default[:gatling][:burst_users] = 100
default[:gatling][:burst_time] = 10
default[:gatling][:ramp_users_start] = 5
default[:gatling][:ramp_users_end] = 40
default[:gatling][:ramp_time] = 90	
default[:gatling][:endurance_users] = 40
default[:gatling][:endurance_time] = 180