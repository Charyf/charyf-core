# frozen_string_literal: true

require_relative 'extension'
require_relative 'app_engine/extensions'

module Charyf
  class AppEngine < Extension

    # Load Charyf generators and invoke the registered hooks.
    # Check <tt>Charyf::Extension.generators</tt> for more info.
    def load_generators(app = self)
      require_relative 'generators'
      Charyf::Generators.configure!(app.config.generators)

      require_relative 'generators/app/app_generator'
      require_relative 'generators/skill/skill_generator'
      require_relative 'generators/intents/intents_generator'

      run_generators_blocks(app)
      self
    end

  end
end