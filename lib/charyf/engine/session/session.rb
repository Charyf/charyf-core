require 'yaml'

module Charyf
  module Engine
    class Session

      attr_reader :uuid, :skill, :controller, :action, :timestamp

      # TODO - mention it could return nil
      # TODO sig
      def self.get(uuid)
        yaml = _storage.get(uuid)
        yaml ? YAML.load(yaml) : nil
      end

      def self.init(uuid, skill_name)
        session = self.new(uuid, skill_name)

        _storage.store(uuid, YAML.dump(session))

        session
      end

      def route_to(controller, action)
        @controller = controller
        @action = action
      end

      def storage
        @storage ||= Charyf.application.storage_provider.get_for("#{self.class}_#{@uuid}")
      end

      def keep!
        @active = true
        store!
      end

      def invalidate!
        @active = false
        self.class._storage.remove(@uuid)
      end

      def store!
        @timestamp = Time.now
        self.class._storage.store(@uuid, YAML.dump(self))
      end

      sig [], ['Symbol', 'String', 'NilClass'],
      def full_controller_name
        @controller.blank? ? nil : @skill.camelize + '::' + @controller.camelize
      end

      private

      def initialize(uuid, skill)
        @uuid = uuid
        @skill = skill
        @active = true
        @timestamp = Time.now
      end

      def self._storage
        @storage ||= Charyf.application.storage_provider.get_for(self)
      end

    end
  end
end