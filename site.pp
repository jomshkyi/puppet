class package_install {
package { 'vim-enhanced':
    provider => yum,
    ensure   => installed,
        }
package { 'curl':
    provider => yum,
    ensure   => installed,
        }

package { 'git':
    provider => yum,
    ensure   => installed,
        }
}

class add_user {

  user { 'monitor':
    ensure     => present,
    home       => '/home/monitor',
    shell      => '/bin/bash',
    managehome => true,
       }
}


class directory_scripts {

file { '/home/monitor/scripts':
    ensure => 'directory',
    owner  => 'monitor',
    group  => 'monitor',
    mode   => '700',
     }
}

class get_script {

exec {'retrieve_script':
  command => "/usr/bin/wget --no-check-certificate https://github.com/jomshkyi/checkmemory_script/raw/master/check_memory.txt -O /home/monitor/scripts/check_memory",
  creates => "/home/monitor/scripts/check_memory",
    }


file{'/home/monitor/scripts/check_memory':
  mode => '777',
  require => Exec["retrieve_script"],
   }	
}


class directory_src {

file { '/home/monitor/src':
    ensure => 'directory',
    owner  => 'monitor',
    group  => 'monitor',
    mode   => '700',
     }
}


class soft_link {
file { '/home/monitor/src/my_memory_check':
    ensure => link,
    target => '/home/monitor/scripts/check_memory',
     }
}

class cron {
cron {'cron':
        command => "sh /home/monitor/src/my_memory_check -w 60 -c 80 -e jesilva@chikka.com",
        minute => '10',
        hour => '*',
        month => '*',
        weekday  => '*',
        monthday => '*',
}
}



node 'bpx.server.local' { 
	include 'package_install' 
	include 'add_user'
	include 'directory_scripts'
	include 'get_script'
	include 'directory_src'
	include 'soft_link'
	include 'cron'
}

