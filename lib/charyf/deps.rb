if %w(development test).include?((ENV['CHARYF_ENV'] || 'development').downcase) || ENV['ENABLE_SIG']
  require 'sig'
  else
  require 'sig/none'
end