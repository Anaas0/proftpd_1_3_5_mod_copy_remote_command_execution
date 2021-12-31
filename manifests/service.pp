#
class proftpd_1_3_5_mod_copy_remote_command_execution::service {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
  # SecGen Parameters
  #$secgen_parameters = secgen_functions::get_parameters($::base64_inputs_file)
  $user = 'proftpd'#$secgen_parameters['leaked_username'][0]
  $user_home = "/home/${user}"

  # Move proftd servive file to correct location.

  # Possibly create a service file for the busy box server.
}
