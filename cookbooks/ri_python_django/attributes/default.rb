default[:django][:major_release] = "1.5"
default[:django][:minor_release] = "4"
default[:django][:release] = node[:django][:major_release] + "." + node[:django][:minor_release]


default[:django][:app] = "ProvidedBy_StackSettings_CustomJson"
default[:django][:app_root] = node[:rawiron][:app_dir] + "/src"
default[:django][:app_dir] = node[:django][:app_root] + "/" + node[:django][:app]


default[:django][:data_root] = node[:rawiron][:app_dir] + "/data"
default[:django][:sqlite][:data] = "/var/lib/sqlite3"
default[:django][:databases] = "ProvidedBy_StackSettings_CustomJson"
default[:django][:settings] = "ProvidedBy_StackSettings_CustomJson"
default[:django][:sentry][:enable] = false

default[:python][:pypi_proxy] = false

if node[:django][:app] == 'ProvidedBy_StackSettings_CustomJson'
	Chef::Log.error("Custom Json: no django app found.")
end

if node[:django][:databases] == 'ProvidedBy_StackSettings_CustomJson'
	Chef::Log.error("Custom Json: no django databases found.")
	node.override[:django][:databases] = {}
end

if node[:django][:settings] == 'ProvidedBy_StackSettings_CustomJson'
	Chef::Log.error("Custom Json: no django settings found.")
end