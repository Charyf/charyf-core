require_relative 'commands/base'
require_relative 'commands/cli'
require_relative 'commands/console'
require_relative 'tools'

module Charyf
  module Commands

    extend self

    def invoke(command, *args)
      case command
        when 'help', 'h'
          print_help
        when 'console', 'c'
          Console.new(app_root).start
        when 'new'
          name = args.first
          if name == nil
            handle_error 'Wrong project name'
          end

          # TODO generate project
          puts "Generating project #{name}"
        else
          handle_error "Unknown command '#{command}'"
      end


    end

    def app_root
      Charyf::Tools.find_root_with_flag 'config.ru', Dir.pwd
    end

    def handle_error(msg)
      $stderr.puts msg

      print_help

      exit(1)
    end

    def print_help
      puts ''
      puts 'Usage: charyf [command]'
      puts '  charyf new [name]               generate new project'
      puts '  charyf server                   start the charyf server'
      puts '  charyf console                  start the developer console'
    end

  end
end