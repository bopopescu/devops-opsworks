default[:rawiron][:app_domain] = "ProvidedBy_StackSettings_CustomJson"
default[:rawiron][:app] = "ProvidedBy_StackSettings_CustomJson"

default[:rawiron][:stack][:loadbalancers] = false
default[:rawiron][:stack][:db_servers] = {}
default[:rawiron][:stack][:cache_servers] = {}


default[:rawiron][:web_root] = "/var/www"
default[:rawiron][:app_dir] = node[:rawiron][:web_root] + "/" + node[:rawiron][:app]
default[:rawiron][:nginx_dir] = node[:rawiron][:app_dir]
default[:rawiron][:requires_dir] = node[:rawiron][:app_dir]

default[:rawiron][:web_user] = "www-data"
default[:rawiron][:web_group] = "www-data"

default[:rawiron][:fqdn] = "<your-domain>.com"

default[:rawiron][:backends_url] = "https://s3.amazonaws.com/us.<your-s3-folder>/dev/backends/chef"


if node[:rawiron][:app_domain] == 'ProvidedBy_StackSettings_CustomJson'
	Chef::Log.error("custom json: no app_domain found.")
end

if node[:rawiron][:app] == 'ProvidedBy_StackSettings_CustomJson'
	Chef::Log.error("custom json: no app found.")
end

db_servers = node[:rawiron][:stack][:db_servers]
if not db_servers.empty?
	['layer', 'engine', 'type'].each do | required_attribute |
		if not db_servers.has_key?(required_attribute)
			Chef::Log.error("custom json: required db_servers attribute #{required_attribute} missing.")
		end
	end
end