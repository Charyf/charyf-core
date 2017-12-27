# frozen_string_literal: true

require_relative 'extension'

module Charyf
  class AppEngine < Extension

    generators do
      require_relative 'generators/app/app_generator'
      require_relative 'generators/test/test_generator'
    end

    # Load Rails generators and invoke the registered hooks.
    # Check <tt>Rails::Railtie.generators</tt> for more info.
    def load_generators(app = self)
      require_relative 'generators'
      run_generators_blocks(app)
      Charyf::Generators.configure!(app.config.generators)
      self
    end

  end
end