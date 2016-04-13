# use opsworks STACK SETTING
#node.override['riak']['config']['riak_core']['ring_creation_size'] = 64

# riak_kv bitcask
# 2G = 2147483648
# 1G = 1073741824
# 500M = 524288000
default['riak']['config']['bitcask']['max_file_size'] = 524288000 + rand(524288000)
default['riak']['config']['bitcask']['sync_strategy'] = "none"
default['riak']['config']['bitcask']['merge_window'] = "always"

default['riak']['config']['bitcask']['frag_merge_trigger'] = 60
default['riak']['config']['bitcask']['dead_bytes_merge_trigger'] = 536870912

default['riak']['config']['bitcask']['frag_threshold'] = 40
default['riak']['config']['bitcask']['dead_bytes_threshold'] = 134217728
default['riak']['config']['bitcask']['small_file_threshold'] = 10485760