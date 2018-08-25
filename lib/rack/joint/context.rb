module Rack
  class Joint
    class Context
      attr_reader :responses
      def initialize
        @responses = []
      end

      # @param  old_host [String] Hostname set as argument in `config.ru`.
      # @param  &block   [block] Given block with `host`.
      # @return [Array] Return Array consisted of block under `redirect`.
      def host(old_host, &block)
        responses << {
          "#{old_host}" => Redirect.new(old_host).instance_exec(&block)
        }
      end
    end
  end
end