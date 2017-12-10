require 'erb'

module Charyf
  module Controller
    module Renderers

      class ResponseFileMissingError < StandardError; end
      class NoResponseFound < StandardError; end
      class InvalidState < StandardError; end
      class InvalidDefinitionError < StandardError; end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def auto_reply(only: [], except: [])
          if only && !only.empty? && except && !except.empty?
            raise InvalidDefinitionError.new("Define only or except, don't define both");
          end

          @_render_on = (except && !except.empty?) ? :all : only.map(&:to_sym)
          @_dont_render_on = except.map(&:to_sym)
        end

        def _render_on?(action)
          (@_render_on == :all && !@_dont_render_on.include?(action.to_sym)) ||
              ((@_render_on != :all) && (@_render_on || []).include?(action.to_sym))
        end

      end # End of ClassMethods

      # TODO sig
      def response_folder
        return nil if skill_name.to_s.blank?

        return skill_name.to_s.constantize.skill_root.join('responses', controller_path)
      end

      def ensure_responses_for(action)
        unless response_folder
          raise Charyf::Controller::Renderers::InvalidState.new('Controller without skill can not render views')
        end

        if responses_for(action).empty?
          raise Charyf::Controller::Renderers::NoResponseFound.new('No responses files found for action ' + action.to_s + "\n" +
                                                                       "Expected #{action}.[html|txt].erb in #{response_folder}")
        end
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
        controller_name.underscore
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