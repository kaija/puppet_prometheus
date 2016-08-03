#
#
#
define prometheus::alertmanager (
    $port           = '9093',
    $external_url   = 'http://127.0.0.1:9093/alert'
){
    $alertmanager_web_prefix = $external_url
    $alertmanager_port = $port
    package{'alertmanager':
        ensure  => installed,
    }
    service{'alertmanager':
        ensure  => running,
        enable  => true,
    }
    exec {
        'alertmanager-upstart-reload':
            command     => '/sbin/initctl reload-configuration',
            refreshonly => true,
            notify      => Service['alertmanager'],
    }
    file {
        '/etc/init/alertmanager.conf':
            ensure      => 'file',
            owner       => root,
            group       => root,
            mode        => '0644',
            backup      => false,
            force       => true,
            notify      => Exec['alertmanager-upstart-reload'],
            content     => template('prometheus/etc/init/alertmanager.conf.erb');
    }
}
