extract_tool = "#{node[:cloud][:tools_dir]}/bin/extract"
cookbook_file "#{extract_tool}" do
  cookbook "ri_scm_helper"
  source "extract.rb"
  mode 0755
  owner "root"
  group "root"
  not_if { ::File.exists?("#{extract_tool}") }
end


package "curl" do
  action :upgrade
end

s3curl_tool = "#{node[:cloud][:tools_dir]}/bin/s3curl.pl"
cookbook_file "#{s3curl_tool}" do
  cookbook "ri_scm_helper"
  source "s3curl.pl"
  mode 0755
  owner "root"
  group "root"
  not_if { ::File.exists?("#{s3curl_tool}") }
end