define :ri_ebs_mount do
  Chef::Log.info("ebs : mount")
  
  app_service = params[:service]
  app_mount_dir = params[:mount_dir]
  app_owner = params[:owner]
  app_group = params[:group]

  ec2_path = params[:ec2_path]
  ec2_ebs_mount = params[:ec2_ebs_mount]

  autofs_entry = "#{app_mount_dir} #{node[:ebs][:autofs_options]} :#{ec2_path}"

  if ec2_path == ec2_ebs_mount
    Chef::Log.error("ebs : mount is identical to path")
  end


  Chef::Log.info("ebs : bind-mount to EBS")

  if (ec2_path && ! FileTest.directory?(ec2_path))
    Chef::Log.info("ebs : setup")

    service app_service do
      action :stop
      only_if { app_service }
    end

    execute "Copy data to EBS for first init" do
      command "mv #{app_mount_dir} #{ec2_path}"
      not_if do
        FileTest.directory?(ec2_path)
      end
    end

    [app_mount_dir, ec2_path].each do |dir|
      directory dir do
        owner app_owner
        group app_group
      end
    end

  else
    Chef::Log.info("ebs : Skipping setup - using what is already on the EBS volume")
  end


  Chef::Log.info("ebs : auto-mount from EBS")
  ruby_block "adding bind mount for #{app_mount_dir} to #{node[:ebs][:opsworks_autofs_map_file]}" do
    block do
      handle_to_map_file = Chef::Util::FileEdit.new(node[:ebs][:opsworks_autofs_map_file])
      handle_to_map_file.insert_line_if_no_match(app_mount_dir, autofs_entry)
      handle_to_map_file.write_file
    end

    notifies :restart, "service[autofs]", :immediately
  end


  service app_service do
    action :start
    only_if { app_service }
  end

end
