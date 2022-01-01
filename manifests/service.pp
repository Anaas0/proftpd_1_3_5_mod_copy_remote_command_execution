#
class proftpd_1_3_5_mod_copy_remote_command_execution::service {
  require proftpd_1_3_5_mod_copy_remote_command_execution::config
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  # SecGen Parameters
  #$secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)

  # Copy BusyBox script to /usr/bin/
  file { '/usr/bin/WebServer.sh':
    source  => 'puppet:///modules/proftpd_1_3_5_mod_copy_remote_command_execution/WebServer.sh',
    mode    => '0777',
    require => Exec['set-perms'],
    notify  => File['/etc/systemd/system/website.service'],
  }

  # Copy BusyBox service file to /etc/systemd/system/  #/lib/systemd/system/
  file { '/etc/systemd/system/website.service':
    source  => 'puppet:///modules/proftpd_1_3_5_mod_copy_remote_command_execution/website.service',
    mode    => '0777',
    require => File['/usr/bin/WebServer.sh'],
    notify  => File['/etc/systemd/system/proftpd.service'],
  }

  # sudo chmod +x /usr/bin/script.sh

  # Copy proftpd service file to correct location
  file { '/etc/systemd/system/proftpd.service':
    source  => 'puppet:///modules/proftpd_1_3_5_mod_copy_remote_command_execution/proftpd.service',
    mode    => '0777',
    require => File['/etc/systemd/system/website.service'],
    notify  => Service['website'],
  }

  # Start services

  # Web Server
  service { 'website':
    ensure  => running,
    enable  => true,
    require => File['/etc/systemd/system/proftpd.service'],
    notify  => Service['proftpd'],
  }

  # Proftpd
  service { 'proftpd':
    ensure  => running,
    enable  => true,
    require => Service['website'],
  }
}
