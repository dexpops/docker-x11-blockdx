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
  min = "5s"
  max = "10s"
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

  command = "/usr/bin/supervisorctl restart blocknetdx-qt"

  command_timeout = "60s"

  error_on_missing_key = false

  perms = 0644

  backup = true

  left_delimiter  = "{{"
  right_delimiter = "}}"

  wait {
    min = "2s"
    max = "10s"
  }
}

template {

  # contents = "{{ keyOrDefault \"service/redis/maxconns@east-aws\" \"5\" }}"
  source = "/home/blocknet/.blocknetdx/blocknetdx.conf.ctmpl"
  destination = "/home/blocknet/.blocknetdx/blocknetdx.conf"

  create_dest_dirs = true

  command = "/usr/bin/supervisorctl restart blocknetdx-qt"

  command_timeout = "60s"

  error_on_missing_key = false

  perms = 0644

  backup = true

  left_delimiter  = "{{"
  right_delimiter = "}}"

  wait {
    min = "2s"
    max = "10s"
  }

}

template {

  # contents = "{{ keyOrDefault \"service/redis/maxconns@east-aws\" \"5\" }}"
  source = "/home/blocknet/.config/BLOCK-DX/app-meta.json.ctmpl"
  destination = "/home/blocknet/.config/BLOCK-DX/app-meta.json"

  create_dest_dirs = true

  command = "supervisorctl restart blockdx"

  command_timeout = "60s"

  error_on_missing_key = false

  perms = 0644

  backup = true

  left_delimiter  = "{{"
  right_delimiter = "}}"

  wait {
    min = "2s"
    max = "10s"
  }

}

template {

  # contents = "{{ keyOrDefault \"service/redis/maxconns@east-aws\" \"5\" }}"
  source = "/usr/local/bin/start-blockdx.ctmpl"
  destination = "/usr/local/bin/start-blockdx"

  create_dest_dirs = true

  command = "supervisorctl restart blockdx"

  command_timeout = "60s"

  error_on_missing_key = false

  perms = 0755

  backup = true

  left_delimiter  = "{{"
  right_delimiter = "}}"

  wait {
    min = "2s"
    max = "10s"
  }

}