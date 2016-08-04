#
#
#
define prometheus::scrape(
    $port               =  undef,
    $path               =  '/metrics',
    $interval           =  '60',
    $ips                =  undef,
    $config_file        =  '/etc/prometheus/prometheus.yml',
) {
    if $label and $port {
        fail('please define label and port')
    }
    $targets = ip2target($ips, $port)
    concat::fragment { "prometheus-scrape-${name}":
        target      =>  $config_file,
        order       =>  '40',
        content     =>  template('prometheus/prometheus_scrape_block.erb'),
    }
}
