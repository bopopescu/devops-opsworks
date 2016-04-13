Chef::Log.info("uwsgi : install pcre package")

package "libpcre3" do
  action :upgrade
end

package "libpcre3-dev" do
  action :upgrade
end