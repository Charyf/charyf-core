# frozen_string_literal: true

require 'charyf/utils/app_loader'

# If we are inside a Charyf application this method performs an exec and thus
# the rest of this script is not run.
Charyf::AppLoader.exec_app

require 'charyf/utils/ruby_version_check'
Signal.trap("INT") { puts; exit(1) }

require 'charyf/utils/command'

Charyf::Command.invoke :application, ARGV
