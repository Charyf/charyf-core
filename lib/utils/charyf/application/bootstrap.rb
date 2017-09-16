module Charyf
  class Application
    module Bootstrap

      include Charyf::Initializable

      initializer :load_environment, group: :all do |p|
        # noinspection RubyResolve
        puts "Charyf starting in #{Charyf.env} mode."
        require self.config.root.join('config', 'environments', "#{Charyf.env}.rb")
      end


    end
  end
end