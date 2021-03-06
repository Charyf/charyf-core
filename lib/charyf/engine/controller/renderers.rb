require 'erb'

require_relative '../../utils'

module Charyf
  module Controller
    module Renderers

      class ResponseFileMissingError < StandardError; end
      class NoResponseFound < StandardError; end
      class InvalidState < StandardError; end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def auto_reply(on_all = nil, only: [], except: [])
          @_render_filters = Charyf::Utils.create_action_filters(on_all, only, except)
        end

        def _render_on?(action)
          Charyf::Utils.match_action_filters?(action.to_sym, _render_filters)
        end

        def _render_filters
          @_render_filters ||= Charyf::Utils.create_action_filters
        end

      end # End of ClassMethods

      def response_folder
        return nil if skill.nil?

        return skill.skill_root.join('responses', controller_path)
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

      def responses_for(action)
        Dir[response_folder.join("#{action}**")]
      end

      def render_text_response(action)
        file_path = response_folder.join("#{action}.txt.erb")

        return nil unless exists?(file_path)

        _render_sample_response file_path
      end

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


      def controller_path
        controller_name.underscore
      end

      def exists?(path)
        File.exists?(path)
      end

      def exists!(path)
        raise ResponseFileMissingError.new(path) unless exists?(path)
      end

    end
  end
end