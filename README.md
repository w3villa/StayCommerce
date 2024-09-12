# Stay
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "stay"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install stay

```

To make the engine's functionality accessible from within an application, it needs to be mounted in that application's config/routes.rb file:
```
mount Stay::Engine, at: "/stay"

```
To copy these migrations into the application run the following command from the application's root:
Or install it yourself as:
```bash
	$ bin/rails stay:install:migrations

```
## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
