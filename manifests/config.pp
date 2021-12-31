#
class proftpd_1_3_5_mod_copy_remote_command_execution::config {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  # SecGen Parameters
  #$secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $user = 'proftpd'#$secgen_parameters['leaked_username'][0]
  $user_home = "/home/${user}"

  # Create /var/www/html/

  # Move index.html or dummy website to /var/www/html/ 

  # Set perms for /var/www/html/

  # Start the busy box server 'sudo busybox httpd -h /var/www/html/'
}
