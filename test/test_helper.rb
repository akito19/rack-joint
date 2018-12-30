$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "rack/joint"
require "minitest/autorun"

def single_path_config
  Rack::Builder.parse_file('test/config/redirect_config.ru').first
end

def multiple_paths_config
  Rack::Builder.parse_file('test/config/multiple_paths.ru').first
end

def multiple_hosts_config
  Rack::Builder.parse_file('test/config/multiple_hosts.ru').first
end

def only_host_config
  Rack::Builder.parse_file('test/config/change_host_with_each_path.ru').first
end

def same_host_config
  Rack::Builder.parse_file('test/config/redirect_different_path_with_same_host.ru').first
end

def same_url_config
  Rack::Builder.parse_file('test/config/set_same_url.ru').first
end

def get_url_with_ssl_config
  Rack::Builder.parse_file('test/config/redirect_with_ssl.ru').first
end

def redirect_all_paths
  Rack::Builder.parse_file('test/config/change_host_with_all_paths.ru').first
end
