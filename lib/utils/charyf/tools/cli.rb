require 'irb'

module Charyf
  module Tools
    module CLI

      class InvalidProjectError < StandardError; end

      extend self

      def start(ap_path)
        validate_path(ap_path)
        load_app(ap_path)

        ::IRB.start(ap_path)
      end

      private

      def load_app(ap_path)
        require File.expand_path('config/environment.rb', ap_path)
      end

      def validate_path(ap_path)
        raise InvalidProjectError.new("\nApp path: '#{ap_path}' is not a valid Charyf project") unless has_gemfile?(ap_path) && has_environment?(ap_path)
      end

      def has_gemfile?(ap_path)
        File.exists?(File.expand_path('Gemfile', ap_path))
      end

      def has_environment?(ap_path)
        File.exists?(File.expand_path('config/environment.rb', ap_path))
      end

    end
  end
end