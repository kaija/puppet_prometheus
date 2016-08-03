

Example:

class {'prometheus':
    prometheus_external_url  => 'http://localhost:9090/prom/',
}


prometheus::scrape{"mysqld":
    port            => '9140',
    config_file     => $config_file,
    ips             => ['127.0.0.1']
}
prometheus::rule{"default_rule":
    config_file     => $config_file,
    rule_files      => ['/etc/prometheus/rules/default.rule']
}


class {'prometheus::exporter::node':
    port            => '9100',
}

class {'prometheus::exporter::mysqld':
    port            => '9100',
    db_user         => 'exporter',
    db_pass         => '123456',
    db_host         => 'localhost',
    db_port         => '3306',
}

