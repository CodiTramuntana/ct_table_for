# Rails Responsive Table

**[Rails Responsive Table](https://github.com/CodiTramuntana/ct_table_for)** is a rails table builder for an ActiveRecord collection.

## Optional gems

* [Bootstrap](http://getbootstrap.com/)
* [Font Awesome](http://fontawesome.io/)
* [Ransack](https://github.com/activerecord-hackery/ransack)
* [Paperclip](https://github.com/thoughtbot/paperclip)
* [CanCanCan](https://github.com/CanCanCommunity/cancancan)

## Installation

Add it to your Gemfile:

`gem 'ct_table_for', '~> 0.1.8'`

Then:

`bundle`

Then require the CSS in your `application.css` file:

```css
/*
 *= require table_for
 */
```

or in sass

```sass
@import "table_for"
```

## Usage

To get started, just use the `table_for_for` helper. Here's an example:

```erb
<%= table_for Model, @collection %>
```

### Customizing

Create config variables in your app's /config/initializers/ct_table_for.rb

```ruby
CtTableFor.setup do |config|
  config.table_for_wrapper_default_class = "table-responsive"
  config.table_for_default_class = "table table-striped table-bordered table-condensed table-hover"
  config.table_for_breakpoint = "992px" # or could be done by sass
  config.table_for_icon_font = "fa"
  config.table_for_action_icons = {show: "eye", edit: "pencil", destroy: "trash"}
  config.table_for_numeric_percent_precision = 2

end
```
You can also define the breakpoint in your `sass` before importing `table_for`:

```sass
$table-for-breakpoint: 768px;
@import "table_for"
```


## Development

To develop the Gem, clone this repo and in your Rails Test application edit the `Gemfile` and edit the path to your local repo:

```
gem 'table_for', path: '/home/user/path/to/table_for'
```


## Contributing

Bug reports and pull requests are welcome on GitHub. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

`table_for` is Copyright © 2017 CodiTramuntana SL. It is free software, and may be redistributed under the terms specified in the LICENSE file.

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

# About CodiTramuntana

![CodiTramuntana's Logo](https://avatars0.githubusercontent.com/u/27996979?v=3&u=b0256e23ae7b2f237e3d1b5f2b2abdfe3092b24c&s=400)

Maintained by [CodiTramuntana](http://www.coditramuntana.com).

The names and logos for CodiTramuntana are trademarks of CodiTramuntana SL.

We love open source software!
