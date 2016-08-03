#
#
#
class prometheus::exporter::mysqld (
    $port    = '9100',
    $db_host = 'localhost',
    $db_port = '3306',
    $db_user = 'exporter',
    $db_pass = 'password',
){
    $exporter_port = $port
    package{'mysqld-exporter':
        ensure  => installed,
    }
    service{'mysqld-exporter':
        ensure  => running,
        enable  => true,
    }
    exec {
        'mysqld-exporter-upstart-reload':
            command     => '/sbin/initctl reload-configuration',
            refreshonly => true,
            notify      => Service['mysqld-exporter'],
    }
    file {
        '/etc/init/mysqld-exporter.conf':
            ensure      => 'file',
            owner       => root,
            group       => root,
            mode        => '0644',
            backup      => false,
            force       => true,
            notify      => Exec['mysqld-exporter-upstart-reload'],
            content     => template('prometheus/etc/init/mysqld-exporter.conf.erb');

        '/etc/default/mysqld-exporter.conf':
            ensure      => 'file',
            owner       => root,
            group       => root,
            mode        => '0644',
            backup      => false,
            force       => true,
            notify      => Service['mysqld-exporter'],
            content     => template('prometheus/etc/default/mysqld-exporter.erb');
    }

}
