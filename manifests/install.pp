#
# Class: proftpd_1_3_5_mod_copy_remote_command_execution::install
#
class proftpd_1_3_5_mod_copy_remote_command_execution::install {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], environment => [ 'http_proxy=172.22.0.51:3128', 'https_proxy=172.22.0.51:3128' ] }
  # SecGen Parameters
  #$secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $user = 'proftpd'#$secgen_parameters['leaked_username'][0]
  $user_home = "/home/${user}"

  exec { 'set-nic-dhcp':
    command   => 'sudo dhclient ens3',
    notify    => Exec['set-sed'],
    logoutput => true,
  }
  exec { 'set-sed':
    command   => "sudo sed -i 's/172.33.0.51/172.22.0.51/g' /etc/systemd/system/docker.service.d/* /etc/environment /etc/apt/apt.conf /etc/security/pam_env.conf",
    notify    => User["${user}"],
    logoutput => true,
  }

  # Create user(s)
  user { "${user}":
    ensure     => present,
    uid        => '666',
    gid        => 'root',#
    home       => "${user_home}/",
    managehome => true,
    require    => Exec['set-sed'],
    notify     => Package[''],
  }

  # Install dependancies
  package { 'build-essential':
    ensure  => installed,
    require => User["${user}"],
    notify  => Package['gcc-multilib'],
  }
  package { 'gcc-multilib':
    ensure  => installed,
    require => Package['build-essential'],
    notify  => File['/opt/proftpd_1_3_5/'],
  }

  # Make install directory
  file { '/opt/proftpd_1_3_5/':
    ensure  => directory,
    owner   => $user,
    mode    => '0777',
    require => Package['gcc-multilib'],
    notify  => File['/opt/proftpd_1_3_5/proftpd_1_3_5.tar.gz'],
  }
  # Copy tar ball
  file { '/opt/proftpd_1_3_5/proftpd_1_3_5.tar.gz':
    source  => 'puppet:///modules/proftpd_1_3_5_mod_copy_remote_command_execution/proftpd_1_3_5.tar.gz',
    owner   => $user,
    mode    => '0777',
    require => File['/opt/proftpd_1_3_5/'],
    notify  => Exec['mellow-file'],
  }
  # Extract
  exec { 'mellow-file':
    cwd     => '/opt/proftpd_1_3_5/',
    command => 'sudo tar -xzvf proftpd_1_3_5.tar.gz',
    creates => '/opt/proftpd_1_3_5/proftpd-1.3.5/',
    require => File['/opt/proftpd_1_3_5/proftpd_1_3_5.tar.gz'],
    notify  => Exec[''],
  }
  # Configure
  exec { 'configure':
    cwd     => '/opt/proftpd_1_3_5/proftpd-1.3.5/',
    command => 'sudo ./configure --with-modules=mod_copy',
    require => Exec['mellow-file'],
    notify  => Exec['make'],
  }
  # Make
  exec { 'make':
    cwd     => '/opt/proftpd_1_3_5/proftpd-1.3.5/',
    command => 'sudo make',
    require => Exec['configure'],
    notify  => Exec['make-install'],
  }
  # Make install
  exec { 'make-install':
    cwd     => '/opt/proftpd_1_3_5/proftpd-1.3.5/',
    command => 'sudo make install',
    require => Exec['make'],
    notify  => Exec['restart-networking'],
  }
  # Standard .conf file should be okay.


# Undo proxy settings
  ############################################## ~PROXY SETTINGS UNDO START~ ##############################################

  exec { 'restart-networking':
    command => 'sudo service networking restart',
    require => File['make-install'],
    notify  => File[""],
  }

  ##############################################  ~PROXY SETTINGS UNDO END~  ##############################################
}
