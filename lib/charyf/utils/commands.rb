# frozen_string_literal: true

require_relative 'command'

aliases = {
    'c' => 'console',
    's' => 'server',
    'g' => 'generate',
    'd' => 'destroy'
}

command = ARGV.shift
command = aliases[command] || command

Charyf::Command.invoke command, ARGV