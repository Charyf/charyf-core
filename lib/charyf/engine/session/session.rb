module Charyf
  module Engine
    class Session

      attr_reader :uuid

      # TODO - mention it could return nil
      # TODO sig
      def self.get(uuid)
        sessions[uuid]
      end

      def self.init(uuid)
        sessions[uuid] = new(uuid)
      end

      def initialize(uuid)
        @uuid = uuid
      end

      def storage
        @storage ||= Hash.new
      end

      private

      def self.sessions
        @_sessions ||= Hash.new
      end

    end
  end
end