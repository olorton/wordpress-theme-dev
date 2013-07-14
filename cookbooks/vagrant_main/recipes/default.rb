include_recipe "apt"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_gd"
include_recipe "php::module_mysql"
include_recipe "nginx"

service "php5-fpm" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "#{node[:nginx][:dir]}/sites-available/wordpress.conf" do
  source "wordpress.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources("service[nginx]"), :delayed
  notifies :restart, resources("service[php5-fpm]"), :delayed
end

execute "Set username of php-fpm to vagrant" do
  cwd "/vagrant/"
  command "sed -i 's/= www-data$/= vagrant/g' /etc/php5/fpm/pool.d/www.conf"
  notifies :restart, resources("service[php5-fpm]"), :delayed
end

if File.exists?("#{node[:nginx][:dir]}/sites-enabled/wordpress")

else
  execute "enable wordpress site" do
    command "sudo ln -s #{node[:nginx][:dir]}/sites-available/wordpress.conf #{node[:nginx][:dir]}/sites-enabled/wordpress"
    notifies :restart, resources("service[nginx]"), :delayed
  end
end

execute "disable default site" do
  command "sudo rm #{node[:nginx][:dir]}/sites-enabled/default"
  only_if do
      File.symlink?("#{node[:nginx][:dir]}/sites-enabled/default")
  end
  notifies :restart, resources("service[nginx]"), :delayed
end

if File.exists?("/vagrant/wordpress/index.php")

else
  execute "download and install wordpress" do
    cwd "/vagrant/"
    command "curl http://wordpress.org/latest.tar.gz | tar xzk --no-same-owner"
    notifies :restart, resources("service[nginx]"), :delayed
  end
end

execute "add wordpress database" do
  command "mysql -u root -e 'CREATE DATABASE IF NOT EXISTS wordpress'"
end
