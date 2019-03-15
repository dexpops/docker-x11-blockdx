# This denotes the start of the configuration section for Consul. All values
# contained in this section pertain to Consul.
consul {

  auth {
    enabled  = false
    username = "test"
    password = "test"
  }

  address = "consul.service.consul:8500"

  token = ""

  retry {

    enabled     = true
    attempts    = 12
    backoff     = "250ms"
    max_backoff = "1m"
  }

  # This block configures the SSL options for connecting to the Consul server.
  ssl {
    enabled = false
    verify  = false
  }

}

reload_signal = "SIGHUP"
kill_signal = "SIGINT"
max_stale = "10m"
log_level = "info"

wait {
  min = "20s"
  max = "60s"
}

deduplicate {
  # This enables de-duplication mode. Specifying any other options also enables
  # de-duplication mode.
  enabled = false
}

exec {
  reload_signal = ""
  kill_signal = "SIGINT"
  kill_timeout = "2s"
}


template {

  # contents = "{{ keyOrDefault \"service/redis/maxconns@east-aws\" \"5\" }}"
  source = "/home/blocknet/.blocknetdx/xbridge.conf.ctmpl"
  destination = "/home/blocknet/.blocknetdx/xbridge.conf"

  create_dest_dirs = true

  error_on_missing_key = true

  perms = 0666

  backup = true

  left_delimiter  = "{{"
  right_delimiter = "}}"

  wait {
    min = "20s"
    max = "60s"
  }

}

template {

  # contents = "{{ keyOrDefault \"service/redis/maxconns@east-aws\" \"5\" }}"
  source = "/home/blocknet/.blocknetdx/blocknetdx.conf.ctmpl"
  destination = "/home/blocknet/.blocknetdx/blocknetdx.conf"

  create_dest_dirs = true

  error_on_missing_key = true

  perms = 0666

  backup = true

  left_delimiter  = "{{"
  right_delimiter = "}}"

  wait {
    min = "20s"
    max = "60s"
  }

}

template {

  # contents = "{{ keyOrDefault \"service/redis/maxconns@east-aws\" \"5\" }}"
  source = "/home/blocknet/.config/BLOCK-DX/app-meta.json.ctmpl"
  destination = "/home/blocknet/.config/BLOCK-DX/app-meta.json"

  create_dest_dirs = true

  error_on_missing_key = true

  perms = 0666

  backup = true

  left_delimiter  = "{{"
  right_delimiter = "}}"

  wait {
    min = "2s"
    max = "10s"
  }

}