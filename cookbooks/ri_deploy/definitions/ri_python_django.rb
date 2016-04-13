define :ri_python_django do
  Chef::Log.info("deploy : application #{params[:app]}")

  deploy = params[:deploy_data]
  application = params[:app]

=begin
  ri_django_dump_static do
    cookbook "ri_python_django"
  end
=end



  ri_deploy_common do
    cookbook "ri_deploy"
    app application
    deploy_data deploy
  end


  include_recipe 'ri_python_django::install_pip'
  
  # pip install -r requirements.txt:
  # subversion servers in /root is required for
  # svn+https://tools:secret@xp-dev.com/svn/Tools/..
  directory "/root/.subversion" do
    user "root"
    group "root"
    mode 0700
    action :create
    not_if { ::File.exists?("/root/.subversion") }
  end

  cookbook_file "/root/.subversion/servers" do
    cookbook "ri_scm_helper"
    source "svn_servers"
    mode 0600
    owner "root"
    group "root"
    #not_if { ::File.exists?("/root/.subversion/servers") }
  end
  
  execute "deploy python modules required" do
    if node[:python][:pypi_proxy]
    	command "pip install -i #{node[:python][:pypi_proxy]} -r requirements.txt"
    else
    	command "pip install --upgrade -r requirements.txt"
    end
    cwd "#{deploy[:deploy_to]}/current"
    action :run
  end


  execute "collect static data" do
    command "python manage.py collectstatic --noinput"
    cwd node[:django][:app_root]
    action :run
  end

  # give django write access to profiles folder
  directory "#{deploy[:deploy_to]}/current/profiles" do
    user deploy[:user]
    group deploy[:group]
    mode 0775
    action :create
    not_if { ::File.exists?("#{deploy[:deploy_to]}/current/profiles") }
  end
  
  directory "#{deploy[:deploy_to]}/current/data" do
    user deploy[:user]
    group deploy[:group]
    mode 0775
  end

end