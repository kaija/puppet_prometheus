#
#
#
class prometheus(
    $config                     = '/etc/prometheus/prometheus.yml',
    $custom_config              = false,
    $enable_alertmanager        = true,
    $enable_pushgateway         = true,
    $alertmanager_url           = 'http://localhost:9093/alert/',
    $prometheus_external_url    = undef,
    $prometheus_web_prefix      = '/prom',
)inherits prometheus::params {
    validate_string($config)

    if $enable_alertmanager {
        prometheus::alertmanager{"alertmanager":
            port => '9093'
        }
    }
    if $enable_pushgateway {
        prometheus::pushgateway{"pushgateway":
            port => '9091'
        }
    }

    $config_file = $config
	package{'prometheus':
		ensure	=> installed,
	}

    exec {
        'prometheus-upstart-reload':
            command     => '/sbin/initctl reload-configuration',
            refreshonly => true,
            notify      => Service['prometheus'],
    }

    file {
        '/etc/init/prometheus.conf':
            ensure      => 'file',
            owner       => root,
            group       => root,
            mode        => '0644',
            backup      => false,
            force       => true,
            notify      => Exec['prometheus-upstart-reload'],
            content     => template('prometheus/etc/init/prometheus.conf.erb');
    }

    if $custom_config == false {
        #ensure prometheus config exist
        concat {$config_file:
            owner   =>  'root',
            group   =>  'root',
        }
        prometheus::global{'prometheus_global':
            scrape_interval     => $scrape_interval,
            evaluation_interval => $evaluation_interval,
            config_file         => $config_file,
        }
        concat::fragment { "prometheus-scrape-header":
            target      =>  $config_file,
            order       =>  '30',
            content     =>  template('prometheus/prometheus_scrape_header.erb'),
        }
        prometheus::scrape{"prometheus_scrape_self":
            port            => '9090',
            config_file     => $config_file,
            ips             => ['127.0.0.1']
        }
        service{'prometheus':
            ensure	  => running,
            enable	  => true,
            subscribe => Concat[$config],
        }
    }else{
        service{'prometheus':
            ensure	  => running,
            enable	  => true,
        }
    }
    #Example
    #prometheus::scrape{"test":
    #    target          => 'test',
    #    port            => '9100',
    #    config_file     => $config_file,
    #    ips             => ['127.0.0.1']
    #}
    #prometheus::rule{"default_rule":
    #    config_file     => $config_file,
    #    rule_files      => ['/etc/prometheus/rules/default.rule']
    #}
}
