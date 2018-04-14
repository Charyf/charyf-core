module Charyf
  module Generators
    module Defaults
      extend self

      SETTINGS = {
          storage: 'memory',
          intents: ['adapt']
      }

      STORAGE_PROVIDERS = {
          memory: {
              gem: 'charyf-memory-storage',
              gem_version: ['>= 0.1'],
              require: 'charyf/memory_storage',
              desc: <<-EOM
Memory storage does not provide permanent storage as the contract may require
but delivers enough capabilities for development and testing.
Should not be used on production environments as it is not persisted.
              EOM
          }
      }

      INTENT_PROCESSORS = {
          adapt: {
              gem: 'adapt-charyf',
              gem_version: ['>= 0.3'],
              require: 'adapt-charyf',
              desc: <<-EOM
Ruby wrapper around python library from mycroft [adapt]. Works offline.
It uses building blocks as regexps or small expressions to define and determine intents.
see more at: https://github.com/Charyf/charyf-adapt-processor
              EOM
          },
          wit: {
              gem: 'witai-charyf',
              gem_version: ['>= 0.2'],
              require: 'witai/charyf',
              desc: <<-EOM
Charyf wrapper around WIT.ai service. Utilizes powerful NLP (works online as service).
Supports builtin entity tagging like datetimes, amounts, locations and more.
              EOM
          }
      }

      def intents_desc
        desc = "\n"
        desc << "Here is a list of currently available and supported intent processors, \nthat can be enabled during installation"
        desc << "\nIf your processor isn't listed here, you can change it later in your project settings"

        desc << desc(INTENT_PROCESSORS)

        "\t" + desc.gsub("\n", "\n\t")
      end

      def storage_desc
        desc = "\n"
        desc << "Here is a list of currently available and supported storage providers, \nthat can be enabled during installation"
        desc << "\nIf your provider  isn't listed here, you can change it later in your project settings"

        desc << desc(STORAGE_PROVIDERS)

        desc

        "\t" + desc.gsub("\n", "\n\t")
      end

      private

      def desc(group)
        desc = ""

        group.each do |name, details|
          desc << "\n" + name.to_s
          desc << "\n\tGem: #{details[:gem]} #{details[:gem_version]}\n"
          desc << "\t" + details[:desc].strip.gsub("\n", "\n\t")
        end

        desc
      end

    end
  end
end
