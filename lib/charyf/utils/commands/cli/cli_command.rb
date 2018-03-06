# frozen_string_literal: true

require_relative '../../command/base'
require_relative '../../command/environment_argument'

module Charyf
  class CLI

    def self.start
      self.new.start
    end

    def start
      build_interface
      print_intro

      begin
        loop do
          detect request_input
        end
      rescue Interrupt
        puts "\n"
        puts 'Exiting CLI'
      end
    end

    private

    def print_intro
      puts <<-EOM
  Initialized #{Charyf.env} environment (Charyf #{Charyf.version})
  Welcome to the Charyf CLI Interface.
  Type ":help" for ist of available commands
  To exit pres ctrl + c
      EOM
    end

    def print_help
      puts <<-EOM
  :help             prints this help
  :exit             quit the charyf cli
                    alternatively use ctrl + d (EOM)  
                                   or ctrl + c (KILL)
      EOM
    end

    def request_input
      print '[User]   '
      input = gets
      exit unless input

      input.strip
    end

    def cli_print(obj)
      print '[Charyf] '
      puts obj
      puts ' - - - '
    end

    def detect(utterance)
      if !utterance || utterance.empty?
        return
      end

      if utterance[0] == ':'
        process_command utterance[1..-1]
        return
      end

      request = @interface.request
      request.text = utterance

      @interface.process(request)

      process_single_request!
    end


    def process_command(command)
      case command
        when 'help'
          print_help
        when 'exit'
          exit(0)
        else
          puts 'Unknown command'
          print_help
      end

    end

    def build_interface
      # TODO - dependency on bad "package"
      @interface = Charyf::Interface::Program.create("cli_#{Process.pid}", Proc.new { |response| cli_print(response.text) })
      $stderr.puts "Created program interface for process ##{Process.pid}."
    end

    def process_single_request!
      Charyf.application.dispatcher.new.dispatch(Charyf::Pipeline.dequeue)
    end

  end

  module Command
    class CliCommand < Base # :nodoc:

      include EnvironmentArgument

      hide_command!

      def perform
        extract_environment_option

        # CHARYF_ENV needs to be set before application is required.
        ENV["CHARYF_ENV"] = options[:environment]

        require_application_and_environment!

        Charyf::CLI.start
      end

    end
  end
end