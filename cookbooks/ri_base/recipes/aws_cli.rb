package 'ec2-api-tools' do
  package_name value_for_platform(
     ['ubuntu'] => {'default' => 'ec2-api-tools'}
  )
  action :upgrade
end

package 'python-pip' do
  package_name value_for_platform(
    ['ubuntu'] => {'default' => 'python-pip'}
  )
  action :upgrade
end

execute "pip install awscli" do
end