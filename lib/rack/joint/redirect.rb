# frozen_string_literal: true

module Rack
  class Joint
    class Redirect
      attr_reader :responses, :request, :old_host
      def initialize(request, old_host)
        @responses = []
        @request = request
        @old_host = old_host
      end

      # @param old_path [String] Path set as argument in `config.ru`.
      # @param &block [block] Given block with `redirect`.
      # @return [Array] Return Array consisted of block under `redirect`.
      def redirect(old_path = nil, &block)
        responses << RedirectInterface.new(request, old_host, old_path, &block).apply!
      end
    end
  end
end
