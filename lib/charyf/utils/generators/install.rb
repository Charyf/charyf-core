require_relative 'base'

module Charyf
  module Generators
    class Install < Charyf::Generators::Base

      # source_root "installing"

      # TODO
      def on_generate
        copy_file 'install file', 'install file'
        copy_file 'executable', 'executable'
      end

    end
  end
end