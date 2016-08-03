#
#
#
define prometheus::global(
    $scrape_interval    =  undef,
    $evaluation_interval=  undef,
    $config_file        =  '/etc/prometheus/prometheus.yml',
    $monitor_label      =  'prometheus',
) {
    concat::fragment { "prometheus-global-block":
        target      =>  $config_file,
        order       =>  '00',
        content     =>  template('prometheus/prometheus_global_block.erb'),
    }
}
