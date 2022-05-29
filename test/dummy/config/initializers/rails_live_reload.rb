RailsLiveReload.setup do |config|
  # app
  # config.watch %r{app/views/.+\.(erb|haml|slim)$}, reload: :on_change
  # config.watch %r{app/helpers/.+\.rb}, reload: :always
  config.watch %r{config/locales/.+\.yml}, reload: :always
  # # Rails Assets Pipeline
  # config.watch %r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}, reload: :always
end
