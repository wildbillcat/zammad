#
# Cookbook Name:: zammad
# Recipe:: default
#

include_recipe 'java'
include_recipe 'nginx'

include_recipe 'postfix' if node['zammad']['local_mta']

include_recipe '::elasticsearch' if node['zammad']['local_es']

if platform?('redhat', 'centos', 'fedora')
  include_recipe 'yum-epel'

  yum_repository 'zammad' do
    description 'Repository for zammad/zammad (stable) packages.'
    baseurl 'https://dl.packager.io/srv/rpm/zammad/zammad/stable/el/7/$basearch'
    gpgkey 'https://dl.packager.io/srv/zammad/zammad/key'
    gpgcheck false
    repo_gpgcheck true
    make_cache false # https://github.com/zammad/zammad/issues/1632
    action :create
    #notifies :delete, 'file[/etc/yum.repos.d/zammad.repo]', :delayed
  end

  ## MONKEYPATCH: Have to delete the zammad repo at the end of the run or chef-client fails on next run
  # https://github.com/zammad/zammad/issues/1632
  file '/etc/yum.repos.d/zammad.repo' do
    action :nothing
  end

  yum_package 'zammad' do
    action :upgrade
    version node['zammad']['version']
  end

elsif platform?('ubuntu') && %w(16.04 18.04).include?(node['platform_version'])

  #sudo apt-get update
  apt_update 'update'
  apt_package 'apt-transport-https'

  apt_repository 'zammad' do
    uri 'https://dl.packager.io/srv/deb/zammad/zammad/stable/ubuntu'
    key 'https://dl.packager.io/srv/zammad/zammad/key'
    distribution '18.04'
    components ['main']
    action :add
    deb_src true
  end

  #sudo apt-get update
  apt_update 'update'

  #sudo apt-get install zammad
  apt_package 'zammad' do
    version node['zammad']['version']
  end
else
  raise "This OS doesn't appear to be supported."
end


if node['zammad']['nginx_bind_all']
  template '/etc/nginx/conf.d/default.conf' do
    mode '0644'
    source 'zammad.conf.erb'
    action :create
    variables ({
        bind_all: node['zammad']['nginx_bind_all'],
        server_name: node['zammad']['nginx_server_name']
    })
  end
  file '/etc/nginx/sites-available/default' do
    action :delete
  end
  file '/etc/nginx/conf.d/zammad.conf' do
    action :delete
  end
  file '/etc/nginx/sites-enabled/zammad.conf' do
    action :delete
  end
  file '/etc/nginx/sites-available/zammad.conf' do
    action :delete
  end
  link '/etc/nginx/sites-enabled/000-default' do
    to '/etc/nginx/sites-available/default'
    action :delete
  end
else
  template '/etc/nginx/conf.d/zammad.conf' do
    mode '0644'
    source 'zammad.conf.erb'
    action :create
    variables ({
        bind_all: node['zammad']['nginx_bind_all'],
        server_name: node['zammad']['nginx_server_name']
    })
  end
end


include_recipe '::elasticsearch' if node['zammad']['local_es']