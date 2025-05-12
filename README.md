# Rails Live Reload

[![RailsJazz](https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/my_other.svg?raw=true)](https://www.railsjazz.com)

[!["Buy Me A Coffee"](https://github.com/igorkasyanchuk/get-smart/blob/main/docs/snapshot-bmc-button-small.png?raw=true)](https://buymeacoffee.com/igorkasyanchuk)

![RailsLiveReload](docs/rails_live_reload.gif)

This is the simplest and probably the most robust way to add live reloading to your Rails app.

Just add the gem and thats it, now you have a live reloading. **You don't need anything other than this gem for live reloading to work**.

Works with:

- views (EBR/HAML/SLIM) (the page is reloaded only when changed views which were rendered on the page)
- partials
- CSS/JS
- helpers (if configured)
- YAML locales (if configured)
- on the "crash" page, so it will be reloaded as soon as you make a fix

The page is reloaded fully with `window.location.reload()` to make sure that every chage will be displayed.

## Usage

Just add this gem to the Gemfile (in development environment) and start the `rails s`.

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

run command:


```bash
rails generate rails_live_reload:install
```
The generator will install an initializer which describes `RailsLiveReload` configuration options.


## How it works

There are 3 main parts:

1) listener of file changes (using `listen` gem)
2) collector of rendered views (see rails instrumentation)
3) JavaScript client that communicates with server and triggers reloading when needed

## Notes

The default configuration assumes that you either use asset pipeline, or that your assets compile quickly (on most applications asset compilation takes around 50-200ms), so it watches for changes in `app/assets` and `app/javascript` folders, this will not be a problem for 99% of users, but in case your asset compilation takes couple of seconds, this might not work propperly, in that case we would recommend you to add configuration to watch output folder.

## Contributing

You are welcome to contribute. See list of `TODO's` below.

## TODO

- reload CSS without reloading the whole page?
- smarter reload if there is a change in helper (check methods from rendered views?)
- generator for initializer
- more complex rules? e.g. if "user.rb" file is changed - reload all pages with rendered "users" views
- check with older Rails versions
- tests or specs
- CI (github actions)
- auto reload when rendered controller was changed

## Troubleshooting

- `Too many open files - pipe` - increase limits by `ulimit -n 10000`

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[<img src="https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/more_gems.png?raw=true"
/>](https://www.railsjazz.com/?utm_source=github&utm_medium=bottom&utm_campaign=rails_live_reload)


[!["Buy Me A Coffee"](https://github.com/igorkasyanchuk/get-smart/blob/main/docs/snapshot-bmc-button-small.png?raw=true)](https://buymeacoffee.com/igorkasyanchuk)
