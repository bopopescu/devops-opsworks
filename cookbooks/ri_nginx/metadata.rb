name "ri_nginx"
maintainer "RawIron"
description "Installs and configures nginx"
license "Apache 2.0"
version "0.1"

supports "ubuntu", ">= 12.04"


depends "nginx"
depends "pcre"
depends "sysctl"
depends "ulimit"

depends "ri_base"
depends "ri_cloud"