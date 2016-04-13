#
# Author:: Seth Thomas (<sthomas@basho.com>)
# Cookbook Name:: riak
# Recipe:: default
#
# Copyright (c) 2013 Basho Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
Chef::Log.info("riak : install, patches")

include_recipe "ulimit" unless node['platform_family'] == "debian"

include_recipe "ri_riak::install"


if node['platform_family'] == "debian"
  file "/etc/default/riak" do
    content "ulimit -n #{node['riak']['limits']['nofile']}"
    owner "root"
    mode 0644
    action :create_if_missing
    #notifies :restart, "service[riak]"
  end
else
  user_ulimit "riak" do
    filehandle_limit node['riak']['limits']['nofile']
  end
end

node['riak']['patches'].each do |patch|
  cookbook_file "#{node['riak']['config']['riak_core']['platform_lib_dir'].gsub(/__string_/,'')}/lib/basho-patches/#{patch}" do
    source patch
    owner "root"
    mode 0644
    checksum
    #notifies :restart, "service[riak]"
  end
end