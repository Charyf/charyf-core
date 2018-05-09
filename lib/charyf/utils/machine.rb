module Charyf
  module Utils
    class Machine

      DefaultExists = Class.new(ArgumentError)
      NotInState = Class.new(ArgumentError)
      InvalidDefinition = Class.new(LoadError)
      InvalidEvent = Class.new(ArgumentError)

      class << self

        def state(name, default: false, final: false, action: nil, &block)
          if default
            raise DefaultExists.new if @_default_state
            @_default_state = name
          end


          _states[name] = {
              action: action || name,
              final: final
          }

          if block
            @_state = name
            block.call
            @_state = nil
          end
        end

        def on(event, go: nil, &block)
          raise NotInState.new unless @_state

          _events(@_state)[event] =
              {
                  go: go,
                  callback: block
              }
        end

        def _default_state
          @_default_state
        end

        # def _final_states
        #   @_final_states ||= [:_terminated]
        # end

        def _states
          @_states ||= {
              _terminated: {
                  action: :_terminated,
                  final: true
              }
          }
        end

        def _events(state)
          @_events ||= Hash.new
          @_events[state] ||= Hash.new
        end

        def build
          _states.each do |state_name, state|
            events = _events(state_name)
            raise InvalidDefinition.new("No transitions from state #{state_name}") if events.empty? && !state[:final]

            _events(state_name).each do |event, details|
              raise InvalidDefinition.new("Transition '#{event}' to undefined state '#{details[:go]}'") unless _states.include?(details[:go])
            end
          end

          raise InvalidDefinition.new('No final states defined.') unless _states.values.any? { |state| state[:final] }
        end

      end # End of class

      attr_reader :state

      def initialize(state = nil)
        @state ||= self.class._default_state
      end

      def trigger!(event, payload = nil)
        raise InvalidEvent.new("No transition defined for event '#{event}' from state '#{@state}'") unless trigger?(event)
        change(event, payload)
      end

      def trigger(event, payload = nil)
        trigger?(event) && change(event, payload)
      end

      def trigger?(event)
        self.class._events(@state).include?(event)
      end

      def terminate
        @state = :_terminated
      end

      def final?
        self.class._states[@state][:final]
      end

      def state?(state)
        @state == state
      end

      def events
        self.class._events(@state).keys
      end

      private

      def change(event, payload)
        transition = self.class._events(@state)[event]

        @state = transition[:go]
        #TODO machine
        callback = transition[:callback]
        callback.call(payload) if callback

        @state
      end

    end
  end
end