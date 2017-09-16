require 'irb'

module Charyf
  module Commands
    class Console < Charyf::Commands::Base

      class InvalidProjectError < StandardError; end

      def initialize(root)
        @root = root
      end

      def start
        load_app

        ::IRB.start(@root)
      end

    end
  end
end