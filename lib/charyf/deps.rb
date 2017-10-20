# Signature checking
if %w(development test).include?((ENV['CHARYF_ENV'] || 'development').downcase) || ENV['ENABLE_SIG']
  require 'charyf_sig'
  else
  require 'charyf_sig/none'
end

# I18n
require 'i18n'