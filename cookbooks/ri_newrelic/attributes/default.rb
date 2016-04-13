#license(s)
node.override['newrelic']['server_monitoring']['license'] = "<your-monit-license>"
node.override['newrelic']['application_monitoring']['license'] = "<your-app-license>"

node.override['newrelic']['application_monitoring']['appname'] = "#{node['opsworks']['stack']['name']}"