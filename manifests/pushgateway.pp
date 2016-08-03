#
#
#
define prometheus::pushgateway (
    $port   = '9091',
){
    $pushgateway_port = $port
    package{'pushgateway':
        ensure  => installed,
    }
    service{'pushgateway':
        ensure  => running,
        enable  => true,
    }
    exec {
        'pushgateway-upstart-reload':
            command     => '/sbin/initctl reload-configuration',
            refreshonly => true,
            notify      => Service['pushgateway'],
    }
    file {
        '/etc/init/pushgateway.conf':
            ensure      => 'file',
            owner       => root,
            group       => root,
            mode        => '0644',
            backup      => false,
            force       => true,
            notify      => Exec['pushgateway-upstart-reload'],
            content     => template('prometheus/etc/init/pushgateway.conf.erb');
    }
}
