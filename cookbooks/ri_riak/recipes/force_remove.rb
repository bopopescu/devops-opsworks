require 'json'

ready_response = Rawiron::Riak.ringready()
Chef::Log.debug("riak : ring ready #{ready_response.to_json}")

plan_response = Rawiron::Riak.force_remove(ready_response)
Chef::Log.debug("riak : cluster plan #{plan_response.to_json}")

Rawiron::Riak.commit(plan_response)
Chef::Log.debug("riak : commit")

ready_response = Rawiron::Riak.ringready()
Chef::Log.debug("riak : ring ready #{ready_response.to_json}")