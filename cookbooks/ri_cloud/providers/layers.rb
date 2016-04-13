def whyrun_supported?
  true
end


action :read do
  if @current_resource.already_read
    Chef::Log.info "#{ @new_resource } already read from Cloud API - nothing to do."
  else
    converge_by("Read #{ @new_resource }") do
      read_layers
    end
  end
end


def load_current_resource
  @current_resource = Chef::Resource::FiCloudLayers.new(@new_resource.name)
  @current_resource.instances(@new_resource.instances)
  @current_resource.my_layer(@new_resource.my_layer)

  if not @current_resource.instances.nil? and
      not @current_resource.my_layer.nil?
    @current_resource.already_read = true
  else
    @current_resource.already_read = false
  end
end


def read_layers
  if @current_resource.instances.nil?
    @current_resource.instances(["dummy"])
  end

  if @current_resource.my_layer.nil?
    @current_resource.my_layer("dummy")
  end 
end