Chef::Log.info("python : install pip from source")

# setuptools
remote_file "/tmp/ez_setup.py" do
  source "https://bitbucket.org/pypa/setuptools/raw/9defd65f85b138adc1bef1923bd1f24f098dfbb9/ez_setup.py"
end

execute "python ez_setup.py" do
  cwd "/tmp"
end


# pip
remote_file "/tmp/pip-1.4.1.tar.gz" do
  source "https://pypi.python.org/packages/source/p/pip/pip-1.4.1.tar.gz#md5=6afbb46aeb48abac658d4df742bff714"
end

execute "tar xzvf /tmp/pip-1.4.1.tar.gz" do
  cwd "/tmp"
end

execute "python setup.py install" do
  cwd "/tmp/pip-1.4.1"
end