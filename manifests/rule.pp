#
#
#
define prometheus::rule(
    $rule_files         =  [],
    $config_file        =  '/etc/prometheus/prometheus.yml',
) {
    $files = $rule_files
    concat::fragment { "prometheus-rule-${name}":
        target      =>  $config_file,
        order       =>  '20',
        content     =>  template('prometheus/prometheus_rule_block.erb'),
    }
}
