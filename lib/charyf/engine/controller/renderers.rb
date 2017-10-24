require 'erb'

module Charyf
  module Controller
    module Renderers

      class ResponseFileMissingError < StandardError; end

      # TODO sig
      def response_folder
        return nil if @intent.skill == nil || @intent.skill.empty?

        return @intent.skill.constantize.skill_root.join('responses', controller_path)
      end

      # TODO sig
      def responses_for(action)
        Dir[response_folder.join("#{action}**")]
      end

      # TODO sig
      def render_text_response(action)
        file_path = response_folder.join("#{action}.txt.erb")

        check_file!(file_path)

        sample = File.read(file_path).split("###").map(&:strip).sample

        ERB.new(sample).result(binding)
      end

      # TODO sig
      def render_html_response(action)
        file_path = response_folder.join("#{action}.html.erb")

        check_file!(file_path)

        sample = File.read(file_path)

        ERB.new(sample).result(binding)
      end

      private

      # TODO sig
      def controller_path
        @intent.controller.sub(@intent.skill + '::', '').underscore
      end

      # TODO sig
      def check_file(path)
        File.exists?(path)
      end

      def check_file!(path)
        raise ResponseFileMissingError.new(path) unless check_file(path)
      end

    end
  end
end