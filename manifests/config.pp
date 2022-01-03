#
class proftpd_1_3_5_mod_copy_remote_command_execution::config {
  require proftpd_1_3_5_mod_copy_remote_command_execution::install
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  # SecGen Parameters
  #$secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)

  # Create /var/www/
  file { '/var/www/':
    ensure  => 'directory',
    mode    => '0777',
    require => Exec['restart-networking'],
    notify  => File['/var/www/html/'],
  }

  # Create /var/www/html/
  file { '/var/www/html/':
    ensure  => 'directory',
    mode    => '0777',
    require => File['/var/www/'],
    notify  => File['/var/www/html/index.html'],
  }

  # Move index.html or dummy website to /var/www/html/
  file { '/var/www/html/index.html':
    source  => 'puppet:///modules/proftpd_1_3_5_mod_copy_remote_command_execution/index.html',
    mode    => '0777',
    require => File['/var/www/html/'],
    notify  => Exec['set-perms'],
  }

  # Set perms for /var/www/html/
  exec { 'set-perms':
    command => 'sudo chmod 777 -R /var/www/html/',
    require => File['/var/www/html/index.html'],
    notify  => File['/usr/bin/WebServer.sh'],
  }
}
