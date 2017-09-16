module Charyf
  class Application
    module Bootstrap

      include Charyf::Initializable

      initializer :load_environment, group: :all do |p|
        puts "Charyf starting in #{Charyf.env} mode."

        # noinspection RubyResolve
        require self.config.root.join('config', 'environments', "#{Charyf.env}.rb")
      end


    end
  end
end