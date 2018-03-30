require 'thread'

module Charyf
  module Pipeline

    class << self

      #
      # This method si blocking
      #
      def dequeue
        _pipeline.deq
      end

      def enqueue(request)
        _pipeline.enq(request)
      end

      private

      def _pipeline
        @pipeline ||= Queue.new
      end

    end

  end
end