# frozen_string_literal: true

module Rack
  class Joint
    class Redirect
      attr_reader :responses
      attr_reader :old_host
      def initialize(old_host)
        @responses = []
        @old_host = old_host
      end

      # @param old_path [String] Path set as argument in `config.ru`.
      # @param &block [block] Given block with `redirect`.
      # @return [Array] Return Array consisted of block under `redirect`.
      def redirect(old_path, &block)
        responses << RedirectInterface.new(old_host, old_path, &block).apply!
      end
    end
  end
end
