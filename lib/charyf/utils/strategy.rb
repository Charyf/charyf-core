module Charyf
  module Strategy

    extend self

    # TODO sig
    def add_speech_processor(processor_name, processor)
      (strategies[:speech] ||= Hash.new)[processor_name] = processor
    end

    # TODO sig
    def get_speech_processor(processor_name)
      (strategies[:speech] ||= Hash.new)[processor_name]
    end

    # TODO sig
    def add_intent_processor(processor_name, processor)
      (strategies[:intent] ||= Hash.new)[processor_name] = processor
    end

    # TODO sig
    def get_intent_processor(processor_name)
      (strategies[:intent] ||= Hash.new)[processor_name]
    end

    # TODO sig
    def add_session_processor(processor_name, processor)
      (strategies[:session] ||= Hash.new)[processor_name] = processor
    end

    # TODO sig
    def get_session_processor(processor_name)
      (strategies[:session] ||= Hash.new)[processor_name]
    end


    private

    sig [], Hash,
    def strategies
      @_strategies ||= Hash.new
    end

  end
end