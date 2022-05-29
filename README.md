# Rails Live Reload

This is the simplest and probably the most robust way to add a support for a live reload to your Rails app.

Just add the gem and thats all - congratulation, now you have a live reload.

Works with:

- views (EBR/HAML/SLIM) (reloading page only if you editing views which were rendered)
- partials
- CSS/JS
- helpers, locales (if you configure)
- on a "crash" page, so once you made a fix page it will be reloaded

Page is reloaded with `window.location.reload()` so it's the most robust way to reload the page because of CSS/JS/etc.

## Usage

Just add gem to the Gemfile (in development environment).

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem "rails_live_reload"
end
```

And then execute:
```bash
$ bundle
```

## Configuration

Default configuration `config/initializers/rails_live_reload.rb`:


```ruby
RailsLiveReload.setup do |config|
  config.url     = "/rails/live/reload"
  config.timeout = 100

  # Watched folders & files
  config.watch %r{app/views/.+\.(erb|haml|slim)$}
  config.watch %r{(app|vendor)/(assets|javascript)/\w+/(.+\.(css|js|html|png|jpg|ts|jsx)).*}, reload: :always
  
  # More examples:
  # config.watch %r{app/helpers/.+\.rb}, reload: :always
  # config.watch %r{config/locales/.+\.yml}, reload: :always
end
```

## How it works

There are 3 main pieces how it works:

1) listener for file changes using `listen` gem
2) collector of rendered views (see rails instrumentation)
3) middleware which is responding to setInterval JS calls

## Contributing

You are welcome to contribute. 

## TODO

- reload CSS without reloading the whole page?
- smarter reload if there is a change in helper (check methods from rendered views?)
- generator for initializer
- check how it works with webpacker/importmaps/etc
- maybe complex rules, e.g. if "user.rb" file is changed - automatically reload all "users" views
- check with older Rails versions

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[<img src="https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/more_gems.png?raw=true"
/>](https://www.railsjazz.com/?utm_source=github&utm_medium=bottom&utm_campaign=rails_live_reload)