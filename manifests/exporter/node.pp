#
#
#
class prometheus::exporter::node (
    $port   =   '9100',
){
    $exporter_port = $port
    package{'node-exporter':
        ensure  => installed,
    }
    service{'node-exporter':
        ensure  => running,
        enable  => true,
    }
    exec {
        'node-exporter-upstart-reload':
            command     => '/sbin/initctl reload-configuration',
            refreshonly => true,
            notify      => Service['node-exporter'],
    }
    file {
        '/etc/init/node-exporter.conf':
            ensure      => 'file',
            owner       => root,
            group       => root,
            mode        => '0644',
            backup      => false,
            force       => true,
            notify      => Exec['node-exporter-upstart-reload'],
            content     => template('prometheus/etc/init/node-exporter.conf.erb');
    }

}
