node.override[:mysql][:datadir] = '/var/lib/mysql'
node.override[:mysql][:basedir] = '/usr/local/mysql'
#node.override[:mysql][:conf_dir] = '/usr/local/mysql'
#node.override[:mysql][:confd_dir] = '/usr/local/mysql/conf.d'
node.override[:mysql][:conf_dir] = '/etc/mysql'
node.override[:mysql][:confd_dir] = '/etc/mysql/conf.d'


node.override[:mysql][:tunable][:innodb_buffer_pool_size] = "#{(node[:cloud][:my_user_memory] * 0.7).to_int}M"
node.override[:mysql][:tunable][:innodb_flush_log_at_trx_commit]  = '2'


default[:mysql][:rundir] = "/var/run/mysqld"
default[:mysql][:build_dir] = "/tmp"
default[:mysql][:source_basedir] = '/usr/local/mysql'

default[:mysql][:version][:release] = "5"
default[:mysql][:version][:major] = "7"
default[:mysql][:version][:minor] = "3-m13"
default[:mysql][:version] = "#{node[:mysql][:version][:release]}.#{node[:mysql][:version][:major]}.#{node[:mysql][:version][:minor]}"

default[:mysql][:install_from] = :source