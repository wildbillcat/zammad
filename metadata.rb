name 'zammad'
maintainer 'Matt Mencel'
maintainer_email 'mr-mencel@wiu.edu'
license 'MIT'
description 'Installs/Configures zammad'
long_description 'Installs/Configures Zammad. Zammad is a web-based, open source user support/ticketing solution.'
issues_url 'https://github.com/WIU/zammad/issues' if respond_to?(:issues_url)
source_url 'https://github.com/WIU/zammad' if respond_to?(:source_url)
chef_version '>= 14.0'

version '0.2.0'

supports 'centos', '>= 7.3'
supports 'ubuntu', '16.04'
supports 'ubuntu', '18.04'

depends 'elasticsearch', '~> 4.2'
depends 'java', '~> 4.3'
depends 'nginx', '~> 7.0'
depends 'postfix'
depends 'yum-epel'
