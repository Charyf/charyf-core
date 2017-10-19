module Charyf
  module Skill
    class Base

      class << self
        attr_accessor :_file_path

        def inherited(subclass)
          Base._subclasses[subclass.name.demodulize] = subclass

          # TODO this should be tested
          subclass._file_path = Pathname.new(caller.first[/^[^:]+/]).dirname
        end

        def _subclasses
          @_subclasses ||= Hash.new
        end

      end

      def self.skill_root
        self._file_path
      end


    end

    def self.list
      Base._subclasses.values
    end

  end
end
