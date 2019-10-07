default['java']['jdk_version'] = '11'

default['postfix']['main']['relayhost'] = 'localhost'

default['zammad']['local_mta'] = true
default['zammad']['local_es'] = true
default['zammad']['use_proxy'] = false
default['zammad']['nginx_bind_all'] = false

default['zammad']['nginx_server_name'] = node['zammad']['nginx_bind_all'] ? 'default_server' : 'localhost'

default['zammad']['version'] = platform?('redhat', 'centos', 'fedora') ? '~>3.1.0' : '3.1.0-1569535934.b232e9fb.bionic'
