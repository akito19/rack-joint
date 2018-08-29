require "rack"
require "rack/joint/context"
require "rack/joint/redirect"
require "rack/joint/redirect_interface"
require "rack/joint/version"

module Rack
  class Joint
    attr_reader :app, :block
    def initialize(app, &block)
      @app = app
      @block = block if block_given?
    end

    def call(env)
      rack_request = Rack::Request.new(env)
      mappings = Context.new(rack_request).instance_exec(&block)
      env_host = rack_request.host
      responses = valid_mapping(mappings, env_host)

      if check_redirect?(rack_request, responses)
        redirect_info(rack_request, responses)
      else
        app.call(env)
      end
    end

    private

    # @param mapping [Array] URI mappings for redirecting.
    # @param host    [String] Requested hostname(env).
    # @return [Array] Return URL mapped responses.
    def valid_mapping(mappings, host)
      return [] unless mappings
      mappings.select { |res| res[host] }.first.values.flatten(1)
    end

    # @param  request   [Rack::Request] Request env.
    # @param  responses [Array] Mapped redirect response information.
    # @return [Boolean]
    def check_redirect?(request, responses)
      current_url = request.url
      responses.map do |res|
        res[2].to_s.include?(current_url)
      end.include?(true)
    end

    # @param  request   [Rack::Request] Request env.
    # @param  responses [Array] Mapped redirect response information.
    # @return [Array] Return response corresponded request.
    def redirect_info(request, responses)
      current_url = request.url
      responses.select do |res|
        res[2].to_s.include?(current_url)
      end.to_a.flatten(1)
    end
  end
end
