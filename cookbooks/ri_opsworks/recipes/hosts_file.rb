def make_private_entry(private_ip, instance_name)
  file('/etc/hosts').must_include "#{private_ip} #{instance_name}"
  file('/etc/hosts').must_include "#{private_ip} #{instance_name}-int"
end

def make_public_entry(public_ip, instance_name)
  file('/etc/hosts').must_include "#{public_ip} #{instance_name}-ext"
end


def insert_instances_of_layers
  node[:opsworks][:layers].each do |layer_name, layer_config|
    layer_config[:instances].each do |instance_name, instance_config|
      if !seen.include?(instance_name) && instance_config[:private_ip]
        make_private_entry(Resolv.getaddress(instance_config[:private_ip]), instance_name)
      end
      if instance_config[:ip]
        make_public_entry(Resolv.getaddress(instance_config[:ip]), instance_name)
      end
      seen << instance_name
    end
  end
end