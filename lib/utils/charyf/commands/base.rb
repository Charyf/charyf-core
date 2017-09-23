module Charyf
  module Commands
    class Base

      attr_reader :app_root

      def initialize(root)
        @app_root = root

        load_app
      end

      protected

      def load_app
        # noinspection RubyResolve
        require File.expand_path('config/environment.rb', app_root)
      end

    end
  end
end