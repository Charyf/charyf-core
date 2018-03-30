require_relative 'info'

module Charyf
  module Skill
    class Base

      include Charyf::Skill::Info

      class << self
        attr_accessor :_file_path, :_file_name

        def inherited(subclass)
          Base._subclasses[subclass.name.demodulize] = subclass

          # TODO this should be tested
          subclass._file_path = Pathname.new(caller.first[/^[^:]+/]).dirname
          subclass._file_name = Pathname.new(caller.first[/^[^:]+/]).basename
        end

        def _subclasses
          @_subclasses ||= Hash.new
        end

      end

      def self.skill_root
        self._file_path.join(self._file_name.sub_ext(''))
      end


    end

    def self.list
      Base._subclasses.values
    end

  end
end
