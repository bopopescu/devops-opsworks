require 'rubygems'
require 'aws-sdk'

require 'socket'


def authenticate
  AWS.config(
    :access_key_id     => '',
    :secret_access_key => '',
    :ec2 => {:region => 'us-west-2'}
  )
end


def guess_server_group(this_hostname)
  if this_hostname.start_with?("db-master")
    return "mysql"
  end
end

def mysql_master?
end

def riak_node?
end


def list_regions
  AWS.regions.each do |region|
    puts region.name
  end
end


def list_instances_by(region)
  puts region.ec2.instances.map(&:id)
end


def ruby_version
  RUBY_VERSION.split('.').map{|s| s.to_int}
end

def ruby_version_18?
  ruby_version.take(2) == [1,8]
end

def ruby_version_2?
  ruby_version.take(1) == [2]
end


def my_hostname
    Socket.gethostname
end

def ask_socket_for_my_private_ip
    pp Socket.ip_address_list
    Socket.ip_address_list
end

GOOGLE_IP = '64.233.187.99'

def local_ip
  # turn off reverse DNS resolution temporarily
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  

  UDPSocket.open do |s|
    s.connect GOOGLE_IP, 1
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end

def my_private_ip
  local_ip
end


def find_instance_by(ec2, my_private_ip)
  ec2.instances.each do |instance|
    if instance.private_ip_address == my_private_ip and
       instance.status == :running
    then
      return instance
    end
  end
  return nil
end

def print_instance(a_instance)
  puts a_instance.id
  puts a_instance.private_ip_address
end

def ebs_volumes(instance)
  ebs_devices = []
  instance.block_devices.each do |device|
    if device.has_key?(:ebs) and
       device[:ebs][:status] == "attached"
    then
      ebs_devices.push(device[:ebs])
    end
  end
  ebs_devices
end

def ebs_snapshots(volume_id)
end



authenticate

s3 = AWS::S3.new()

region = AWS.regions['us-west-2']
ec2 = AWS::EC2.new()

ec2.instances.inject({}) { |m, i| m[i.id] = i.status; m }

my_ip = my_private_ip
p guess_server_group(my_hostname)

my_instance = find_instance_by(ec2, my_ip)
print_instance(my_instance)

my_ebs_volumes = ebs_volumes(my_instance)
volume_id = nil
my_ebs_volumes.each do |ebs|
  volume_id = ebs[:volume_id]
  p volume_id
end

p ebs_snapshots(volume_id)