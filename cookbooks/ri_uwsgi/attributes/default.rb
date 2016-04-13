default[:uwsgi][:app] = node[:rawiron][:app]
default[:uwsgi][:app_root] = node[:rawiron][:app_dir]
default[:uwsgi][:app_dir] = node[:rawiron][:app_dir] + "/src"

default[:uwsgi][:app_ini] = "/etc/uwsgi/apps-available/#{node[:uwsgi][:app]}.ini"

default[:uwsgi][:download_url] = "http://projects.unbit.it/downloads"
default[:uwsgi][:version] = "latest"

default[:uwsgi][:dir] = "/etc/uwsgi"
default[:uwsgi][:run_dir] = "/var/run/uwsgi"
default[:uwsgi][:pid_path] = "/var/run/uwsgi-" + node[:uwsgi][:app] + ".pid"
default[:uwsgi][:log_dir] = "/var/log/uwsgi"
default[:uwsgi][:stats_path] = node[:uwsgi][:log_dir] + "/sstat.socket"
default[:uwsgi][:tmp_dir] = "/tmp"


default[:uwsgi][:user] = "www-data"
default[:uwsgi][:group] = "www-data"
default[:uwsgi][:host] = "127.0.0.1"
default[:uwsgi][:port] = 8000

default[:uwsgi][:newrelic_monitor][:enable] = false


default[:uwsgi][:processes] = node[:cloud][:my_cpu]
default[:uwsgi][:threads] = 16
default[:uwsgi][:max_requests] = 45000
default[:uwsgi][:master] = true
default[:uwsgi][:no_orphans] = false
default[:uwsgi][:die_on_term] = false
default[:uwsgi][:close_on_exec] = false
default[:uwsgi][:lazy] = false
default[:uwsgi][:disable_logging] = false
# currently django admin web site is served
# upload of all static data or upload to google docs takes up to 60s
default[:uwsgi][:harakiri] = 60
default[:uwsgi][:stats] = nil
default[:uwsgi][:emperor] = false
default[:uwsgi][:vacuum] = true
default[:uwsgi][:enable_threads] = false