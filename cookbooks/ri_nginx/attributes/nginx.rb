node.override[:nginx][:gzip_types] = ['text/plain',
                                'text/html',
                                'text/css',
                                'application/x-javascript',
                                'text/xml',
                                'application/xml',
                                'application/xml+rss',
                                'application/json',
                                'text/javascript']

node.override[:nginx][:server_names_hash_bucket_size] = 128
node.override[:nginx][:binary] = "/usr/local/nginx/sbin/nginx"

node.override[:nginx][:user] = node[:rawiron][:web_user]
node.override[:nginx][:group] = node[:rawiron][:web_group]
default[:nginx][:web_root] = node[:rawiron][:web_root]

# In a reverse proxy situation, max clients becomes
# max clients = worker_processes * worker_connections/4
node.override[:nginx][:worker_connections] = 65536
# Elastic Load Balancing will close idle connections after 60 seconds, 
# and it expects back-end instances to have timeouts of at least 60 seconds
node.override[:nginx][:keepalive_timeout] = 70

default[:nginx][:sysctl][:file_max] = 125000
default[:nginx][:disable_default_site] = true

default[:nginx][:caching_proxy][:enable] = false
default[:nginx][:proxy_cache_dir] = "/var/www/cache"
default[:nginx][:proxy_temp_dir] = "/var/www/cache/tmp"

default[:nginx][:install_from] = :source
default[:nginx][:pid_dir] = "/var/run/"
default[:nginx][:source_dir] = "/usr/local/nginx"
default[:nginx][:release] = "1.4.4"
default[:nginx][:build_dir] = "/tmp"