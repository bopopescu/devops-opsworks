require 'resolv'

actions :read
default_action :read

attribute :name, :kind_of => String, :name_attribute => true
attribute :instances, :kind_of => Array, :default => nil
attribute :my_layer, :kind_of => String, :default => nil

attr_accessor :already_read