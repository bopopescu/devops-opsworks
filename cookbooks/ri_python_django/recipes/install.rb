# pip
include_recipe 'ri_python_django::install_pip'


release = node[:django][:release]
major_release = node[:django][:major_release]

# django
remote_file "/tmp/Django-#{release}.tar.gz" do
  source "https://www.djangoproject.com/m/releases/#{major_release}/Django-#{release}.tar.gz"
end

execute "tar xzvf /tmp/Django-#{release}.tar.gz" do
  cwd "/tmp"
end

execute "python setup.py install" do
  cwd "/tmp/Django-#{release}"
end


#
# requirements for dev, stage, prod servers BUT not developer environment
#
package 'python-mysqldb' do
	action :upgrade
end

execute "pip install python-memcached" do
end