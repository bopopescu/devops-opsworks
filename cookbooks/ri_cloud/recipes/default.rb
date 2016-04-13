# testing LWRP
# need LWRP which can return state

layers = ri_cloud_layers "test" do
end

Chef::Log.debug("layers are #{layers}")