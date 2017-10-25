require 'erb'

module Charyf
  module Controller
    module Renderers

      class ResponseFileMissingError < StandardError; end
      class NoResponseFound < StandardError; end
      class InvalidState < StandardError; end

      # TODO sig
      def response_folder
        return nil if @intent.skill.blank?

        return @intent.skill.constantize.skill_root.join('responses', controller_path)
      end

      # TODO sig
      def responses_for(action)
        Dir[response_folder.join("#{action}**")]
      end

      # TODO sig
      def render_text_response(action)
        file_path = response_folder.join("#{action}.txt.erb")

        return nil unless exists?(file_path)

        _render_sample_response file_path
      end

      # TODO sig
      def render_html_response(action)
        file_path = response_folder.join("#{action}.html.erb")

        return nil unless exists?(file_path)

        _render_response file_path
      end

      private

      def _render_sample_response(file)
        sample = File.read(file).split("###").map(&:strip).sample
        ERB.new(sample).result(binding)
      end

      def _render_response(file)
        sample = File.read(file)
        ERB.new(sample).result(binding)
      end


      # TODO sig
      def controller_path
        @intent.controller.sub(@intent.skill + '::', '').underscore
      end

      # TODO sig
      def exists?(path)
        File.exists?(path)
      end

      def exists!(path)
        raise ResponseFileMissingError.new(path) unless exists?(path)
      end

    end
  end
end