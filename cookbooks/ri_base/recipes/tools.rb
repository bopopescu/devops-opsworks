# performance monitors
package "sysstat" do
	action :upgrade
end

package "jnettop" do
  action :upgrade
end

package "iperf" do
  action :upgrade
end


# git client
package "git-core" do
  action :upgrade
end