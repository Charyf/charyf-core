module Charyf
  module Engine
    class Session

      attr_reader :uuid, :skill

      # TODO - mention it could return nil
      # TODO sig
      def self.get(uuid)
        sessions[uuid]
      end

      def self.init(uuid, skill)
        sessions[uuid] = new(uuid, skill)
      end

      def storage
        @storage ||= Hash.new
      end

      private

      def initialize(uuid, skill)
        @uuid = uuid
        @skill = skill
      end

      def self.sessions
        @_sessions ||= Hash.new
      end

    end
  end
end