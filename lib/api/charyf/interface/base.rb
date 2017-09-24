require_relative '../response'

module Charyf
  module API
    module Interface
      class Base

        sig [Charyf::API::Response],
        def reply(response)
          raise 'Override this method'
        end

        def dispatcher
          Charyf.dispatcher
        end

      end
    end
  end
end