# Xcover

Generate a HTML page from Xcode unit test coverage statistics

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xcover', git: 'https://github.com/nimbl3/xcover'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xcover --source https://github.com/nimbl3/xcover
    
**This gem required `xccov` command line tools installed in your machine**

## Usage

Create a yml configuration - `.xcover.yml`

```yaml
target_name: Target Name # - Name of target for xccov
display_name: My awesome app # - (Optional) Display name of the target on the report
display_logo: logo.png # - (Optional) A url or path to the logo for displaying on the report
derived_data_directory: derivedDara # - Path to Derived Data
output_directory: output # - Path to HTML files output directory
ignore: # - Ignorance list contains UNIX files and path formats
*View.*
*Cell.*
/Pods
```

To generate the HTML page, there are 2 ways, either using through CLI or Ruby class

#### CLI Usage

The command will take a default config file named `.xcover.yml` and generate the HTML report page to the output directory

```
xcover
```

#### Ruby Usage

```ruby
require 'xcover'

Xcover::Html.new.generate # This takes the default config file named `.xcover.yml`
```

For the custom config file, pass the name/path when instantiate the class

```ruby
Xcover::Html.new('config/xcover_config.yml').generate
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## About

![Nimbl3](https://dtvm7z6brak4y.cloudfront.net/logo/logo-repo-readme.jpg)

This project is maintained and funded by Nimbl3 Ltd.

We love open source and do our part in sharing our work with the community!
See [our other projects][community] or [hire our team][hire] to help build your product.

[community]: https://github.com/nimbl3
[hire]: https://nimbl3.com/
