$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "rack/joint"
require "minitest/autorun"

def single_path_config
  Rack::Builder.parse_file('test/config/set_single_path_config.ru').first
end

def multiple_paths_config
  Rack::Builder.parse_file('test/config/set_multiple_paths_config.ru').first
end

def multiple_hosts_config
  Rack::Builder.parse_file('test/config/set_multiple_hosts_config.ru').first
end

def only_host_config
  Rack::Builder.parse_file('test/config/set_only_host_config.ru').first
end

def same_host_config
  Rack::Builder.parse_file('test/config/set_same_host_config.ru').first
end

def same_path_config
  Rack::Builder.parse_file('test/config/set_same_path_config.ru').first
end