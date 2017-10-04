module Charyf
  module Generators

    class Base
      def self.source_root(path = nil)
        @_source_root = path if path
        @_source_root
      end

      def self.generate!
        instance = self.new

        instance.run
      end


      def run
        on_generate

        _run
      end

      def on_generate

      end

      def copy_file(source_path, target_path)
        files << [source_path, target_path]
      end


      def file_prefix
        ''
      end

      private

      def files
        @files ||= []
      end

      def _run
        files.each do |source, target|
          puts "Generated #{file_prefix}#{'_' if file_prefix && !file_prefix.empty?}#{target}"
        end
      end
    end

  end
end
