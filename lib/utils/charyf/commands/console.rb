require 'irb'

module Charyf
  module Commands
    class Console < Charyf::Commands::Base

      def start
        ::IRB.start(@root)
      end

    end
  end
end