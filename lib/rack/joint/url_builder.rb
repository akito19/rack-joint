# frozen_string_literal: true
require 'uri'

module Rack
  class Joint
    class UrlBuilder
      attr_reader :scheme, :query, :host, :path
      def initialize(scheme, request_query, host, path)
        @scheme = scheme
        @query = request_query
        @host = host
        @path = path
      end

      # @return [URI] URL with SSL or non-SSL
      def build
        if scheme == 'https'
          https_url_builder
        else
          http_url_builder
        end
      end

      private

      # @return [URI]
      def https_url_builder
        # When query parameters isn't added to request URL,
        # returns empty String object with `Rack::Request::Helper#query_string`.
        if query.empty?
          URI::HTTPS.build({ host: host, path: path }).to_s
        else
          URI::HTTPS.build({ host: host, path: path, query: query }).to_s
        end
      end

      # @return [URI]
      def http_url_builder
        # When query parameters isn't added to request URL,
        # returns empty String object with `Rack::Request::Helper#query_string`.
        if query.empty?
          URI::HTTP.build({ host: host, path: path }).to_s
        else
          URI::HTTP.build({ host: host, path: path, query: query }).to_s
        end
      end
    end
  end
end
