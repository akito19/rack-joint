module Rack
  class Joint
    class Context
      attr_reader :request, :responses
      def initialize(request)
        @request = request
        @responses = []
      end

      # @param  old_host [String] Hostname set as argument in `config.ru`.
      # @param  &block   [block] Given block with `host`.
      # @return [Array] Return Array consisted of block under `redirect`.
      def host(old_host, &block)
        responses << {
          "#{old_host}" => Redirect.new(request, old_host).instance_exec(&block)
        }
      end
    end
  end
end
