node.set[:uwsgi][:host] = node['ipaddress']
node.set[:uwsgi][:port] = 8000

include_recipe "ri_uwsgi::configure_local"