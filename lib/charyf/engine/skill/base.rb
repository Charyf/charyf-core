module Charyf
  module Skill
    class Base

      class << self
        attr_accessor :_file_path, :_subclasses

        def inherited(subclass)
          (@_subclasses ||= []) << subclass

          # TODO this should be tested
          subclass._file_path = Pathname.new(caller.first[/^[^:]+/]).dirname
        end
      end

      def self.skill_root
        self._file_path
      end


    end

    def self.list
      Base._subclasses
    end

  end
end
