RailsLiveReload.configure do |config|
  # config.url     = "/rails/live/reload"
  # Available modes are: :sse (default), :long_polling and :polling
  # config.mode = :sse

  # This is used with :long_polling mode
  # config.timeout = 30
  # config.long_polling_sleep_duration = 0.1

  # This is used with :polling mode
  # config.polling_interval = 100

  # Default watched folders & files
  # config.watch %r{app/views/.+\.(erb|haml|slim)$}
  # config.watch %r{(app|vendor)/(assets|javascript)/\w+/(.+\.(css|js|html|png|jpg|ts|jsx)).*}, reload: :always

  # More examples:
  # config.watch %r{app/helpers/.+\.rb}, reload: :always
  # config.watch %r{config/locales/.+\.yml}, reload: :always
end if defined?(RailsLiveReload)
