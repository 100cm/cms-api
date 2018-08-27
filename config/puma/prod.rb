environment "production"

bind  "unix:///www/star/shared/tmp/sockets/puma.sock"
pidfile "/www/star/shared/tmp/pids/puma.pid"
state_path "/www/star/shared/tmp/sockets/puma.state"
directory "/www/star/current"

workers 2
threads 1,2

daemonize true

activate_control_app 'unix:///www/star/shared/tmp/sockets/pumactl.sock'

prune_bundler