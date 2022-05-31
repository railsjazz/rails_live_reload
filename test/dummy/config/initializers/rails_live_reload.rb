RailsLiveReload.configure do |config|
  # config.url     = "/rails/live/reload"
  # Available modes are: :long_polling (default) and :polling
  # config.mode = :long_polling

  # This is used with :polling mode
  # config.polling_interval = 100

  # Default watched folders & files
  # config.watch %r{app/views/.+\.(erb|haml|slim)$}
  # config.watch %r{(app|vendor)/(assets|javascript)/\w+/(.+\.(css|js|html|png|jpg|ts|jsx)).*}, reload: :always

  # More examples:
  # config.watch %r{app/helpers/.+\.rb}, reload: :always
  # config.watch %r{config/locales/.+\.yml}, reload: :always
end if defined?(RailsLiveReload)
