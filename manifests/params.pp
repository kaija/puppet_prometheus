#
#
#
class prometheus::params {
    $conf_folder            = '/etc/prometheus'
    $scrape_interval        = '60'
    $evaluation_interval    = '60'
}
