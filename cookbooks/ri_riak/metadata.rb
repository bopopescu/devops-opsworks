name "riak"
maintainer "RawIron"
description "Installs and configures Riak distributed data store"
license "Apache 2.0"
version "0.1"

supports "ubuntu", ">= 12.04"

depends "riak"
depends "opsworks_stack_state_sync"
depends "ri_ebs"
depends "ri_cloud"