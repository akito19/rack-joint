# frozen_string_literal: true
require 'uri'

module Rack
  class Joint
    class BadRedirectError < StandardError; end

    class RedirectInterface
      attr_reader :scheme, :request_scheme, :old_host, :old_path
      def initialize(request, old_host, old_path, &block)
        @status = 301
        @scheme = nil
        @request_scheme = request.scheme
        @old_host = old_host
        @old_path = old_path || request.path_info
        instance_exec(&block)
      end

      # @return [Array] Return response given parameters in `config.ru`.
      def apply!
        @scheme ||= request_scheme
        @new_host ||= old_host
        @new_path ||= old_path
        old_url = build_uri(request_scheme, old_host, old_path)
        new_location = build_uri(scheme, @new_host, @new_path)
        if old_url == new_location
          raise BadRedirectError.new('Redirect URL has been declared the same as current URL.')
        end
        [@status, { 'Location' => new_location, 'Content-Type' => 'text/html', 'Content-Language' => '0' }, ["Redirect from: #{old_url}"]]
      end

      private

      # @param scheme [String] 'http' or 'https'
      # @param host [String] Host name
      # @param path [String] Path name
      # @return [URI]
      def build_uri(scheme, host, path)
        if scheme == 'https'
          URI::HTTPS.build({ scheme: scheme, host: host, path: path }).to_s
        else
          URI::HTTP.build({ scheme: scheme, host: host, path: path }).to_s
        end
      end

      # @param flag [Boolean]
      # @return [String] `http` or `https`
      def ssl(flag)
        @scheme =
          if flag
            'https'
          else
            'http'
          end
      end

      # @param status [Integer] `status` parameter when redirecting in `config.ru`.
      # @return [Integer] Return status code.
      def status(status)
        @status =
          case status
          when 302
            302
          when 303
            303
          when 307
            307
          when 308
            308
          else
            301
          end
      end

      # @param host [String] `new_host` parameter to redirect hostname in `config.ru`.
      # @return [String] Return hostname where redirects to.
      def new_host(host)
        @new_host = host
      end

      # @param path [String] `to` parameter to redirect path in `config.ru`
      # @return [String] Return pathname where redirects to.
      def to(path)
        @new_path = path
      end
    end
  end
end

