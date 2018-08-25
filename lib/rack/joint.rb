require "rack"
require "rack/joint/context"
require "rack/joint/redirect"
require "rack/joint/redirect_interface"
require "rack/joint/version"

module Rack
  class Joint
    attr_reader :app
    attr_reader :mappings
    def initialize(app, &block)
      @app = app
      @mappings = Context.new.instance_exec(&block) if block_given?
    end

    def call(env)
      rack_env = Rack::Request.new(env)
      env_host = rack_env.host
      env_path = rack_env.fullpath
      requests = valid_mapping(env_host)

      if check_redirect?(requests, env_path)
        redirect_info(requests, env_path)
      else
        app.call(env)
      end
    end

    private

    # @param host [String] Requested hostname(env)
    # @return [Array] Return URL mapped responses.
    def valid_mapping(host)
      return [] unless mappings
      mappings.select { |res| res[host] }.first.values.flatten(1)
    end

    # @param  requests [Array] Mapped redirect response information.
    # @param  path     [String] Requested pathname(env)
    # @return [Boolean]
    def check_redirect?(requests, path)
      requests.map do |req|
        req[2].to_s.include?(path)
      end.include?(true)
    end

    # @param  requests [Array] Mapped redirect response information.
    # @param  path     [String] Requested pathname(env)
    # @return [Array] Return response corresponded request.
    def redirect_info(requests, path)
      requests.select do |req|
        req[2].to_s.include?(path)
      end.to_a.flatten(1)
    end
  end
end
