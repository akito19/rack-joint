$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "rack/joint"
require "minitest/autorun"

def single_path_config
  Rack::Builder.parse_file('test/config/redirect_config.ru')
end

def multiple_paths_config
  Rack::Builder.parse_file('test/config/multiple_paths.ru')
end

def multiple_hosts_config
  Rack::Builder.parse_file('test/config/multiple_hosts.ru')
end

def only_host_config
  Rack::Builder.parse_file('test/config/change_host_with_each_path.ru')
end

def same_host_config
  Rack::Builder.parse_file('test/config/redirect_different_path_with_same_host.ru')
end

def same_url_config
  Rack::Builder.parse_file('test/config/set_same_url.ru')
end

def get_url_with_ssl_config
  Rack::Builder.parse_file('test/config/redirect_with_ssl.ru')
end

def redirect_all_paths
  Rack::Builder.parse_file('test/config/change_host_with_all_paths.ru')
end
