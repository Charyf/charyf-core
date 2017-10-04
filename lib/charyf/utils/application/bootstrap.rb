require_relative '../initializable'

module Charyf
  class Application
    module Bootstrap

      include Charyf::Initializable

      initializer :load_environment, group: :all do
        Charyf.logger.info "Charyf starting in #{Charyf.env} mode."


        # noinspection RubyResolve
        require self.config.root.join('config', 'environments', "#{Charyf.env}.rb")
      end

      initializer :load_apps, group: :all do
        # TODO Load apps / skills
      end

      initializer :load_initializers, group: :all do
        # Load initializer files
      end


    end
  end
end