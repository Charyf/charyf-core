module Charyf
  class AppEngine < Extension
    class Extensions
      include Enumerable
      attr_reader :_all

      def initialize
        @_all ||= ::Charyf::Extension.subclasses.map(&:instance) +
            ::Charyf::AppEngine.subclasses.map(&:instance)
      end

      def each(*args, &block)
        _all.each(*args, &block)
      end

      def -(others)
        _all - others
      end
    end
  end
end
