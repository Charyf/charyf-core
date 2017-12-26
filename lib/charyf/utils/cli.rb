# frozen_string_literal: true

require_relative 'app_loader'

# If we are inside a Charyf application this method performs an exec and thus
# the rest of this script is not run.
Charyf::AppLoader.exec_app

require_relative 'ruby_version_check'
Signal.trap("INT") { puts; exit(1) }

require_relative 'command'

Charyf::Command.invoke :application, ARGV
