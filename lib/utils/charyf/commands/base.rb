module Charyf
  module Commands
    class Base

      def initialize(root)
        @root = root

        load_app
      end

      protected

      def load_app
        # noinspection RubyResolve
        require File.expand_path('config/environment.rb', @root)
      end

    end
  end
end