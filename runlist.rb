module Rawiron
  module Runlist
   
    attr_accessor :empty, :riak, :gatling, :ganglia, :mysql_memcached, 
                  :ops, :memcached, :nginx, :uwsgi, 
                  :django_deploy, :django_app, :django_dev, :django_prod

    @empty = []
    
    @gatling = ["ri_nginx", "ri_gatling", "ri_deploy::gatling"]
    
    @ganglia = ["ri_ganglia::client", "ri_ganglia",]

    @ops = ["ri_localshop", "ri_jenkins"]


    @elasticsearch = []

    @mysql = []

    @riak = ["ri_riak", "ri_riak::configure",]
    
    @mysql_memcached = ["ri_mysql_memcached_plugin", 
                        "ri_mysql_memcached_plugin::configure", 
                        "ri_mysql_memcached_plugin::client"]

    @memcached = ["monit", "memcached"]


    @haproxy = ["haproxy", "ri_haproxy::configure"]
    @nginx = ["ri_nginx", "ri_nginx::configure_uwsgi"]

    @uwsgi = ["ri_uwsgi", "ri_uwsgi::configure"]


    @django_deploy = ["ri_deploy::python-django",
                      "ri_python_django::configure"]

    @django_app = ["ri_python_django",].concat(@django_deploy)
    
    @django_dev = [].concat(@django_app).concat(
                   ["ri_python_django::reset_databases", 
                   "ri_python_django::start",])

    @django_prod = [].concat(@nginx).concat(@uwsgi).concat(@django_app)

  end
end
