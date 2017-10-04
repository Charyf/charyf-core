require_relative 'base'
require_relative '../interface/program'

module Charyf
  module Commands
    class CLI < Charyf::Commands::Base

      def start
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

      sig [Object],
      def cli_print(obj)
        print '[Charyf] '
        puts obj
        puts ' - - - '
      end

      def detect(utterance)
        if utterance[0] == ':'
          process_command utterance[1..-1]
          return
        end

        # TODO - dependency on bad "package"
        processor = Charyf::Interface::Program.new(Process.pid, Proc.new { |response| cli_print(response.text) })

        request = processor.request
        request.text = utterance

        processor.process(request)
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

    end
  end
end