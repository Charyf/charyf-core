module Charyf
  module Commands
    class Base
      attr_reader :app_root

      sig ['Pathname'], nil,
      def initialize(root)
        @app_root = root

        load_app
      end

      protected

      def load_app
        # noinspection RubyResolve
        require File.expand_path('config/chapp.rb', app_root)
      end

    end
  end
end