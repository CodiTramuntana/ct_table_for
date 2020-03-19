---
layout: default
---

[![Gem Version](https://badge.fury.io/rb/ct_table_for.svg)](https://badge.fury.io/rb/ct_table_for)

**[Rails Responsive Table](https://github.com/CodiTramuntana/ct_table_for)** is a rails table builder for an ActiveRecord collection.

## Optional gems

* [Bootstrap](http://getbootstrap.com/)
* [Font Awesome](http://fontawesome.io/)
* [Ransack](https://github.com/activerecord-hackery/ransack)
* [Paperclip](https://github.com/thoughtbot/paperclip)
* [CanCanCan](https://github.com/CanCanCommunity/cancancan)

## Installation

Add it to your Gemfile:

`gem 'ct_table_for'`

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

And require the necessary javascript in `application.js` if you are using the `clickable` row option (`jQuery` is required):

```js
//= require table_for
```

## Usage

To get started, just use the `table_for` helper. Here's an example:

```erb
<%= table_for Model, @collection %>
```

#### Clickable rows

To make rows clickable just add corresponding option to `table_for` helper:

```erb
<%= table_for Model, @collection, options: { clickable: true } %>
```

It builds a call to a named RESTful route for a given record from a collection.
Also, you can specify your own nested resources path by passing an `array` of symbols:

```erb
<%= table_for Model, @collection, options: { clickable: [:bo, :admin] } %>
```


### Customizing

Create config variables in your app's /config/initializers/ct_table_for.rb

```ruby
CtTableFor.setup do |config|
  config.table_for_wrapper_default_class = "table-responsive"
  config.table_for_default_class = "table table-striped table-bordered table-condensed table-hover"
  config.table_for_default_action_base_class = "btn btn-sm"
  config.table_for_action_class = {show: "btn-primary", edit: "btn-success", destroy: "btn-danger", other: "btn-default"}
  config.table_for_breakpoint = "992px" # or could be done by sass
  config.table_for_icon_font = "fa"
  config.table_for_action_icons = {show: "eye", edit: "pencil", destroy: "trash"}
  config.table_for_numeric_percentage_precision = 2
  config.table_for_cell_for_image_image_class = "img-responsive"
  config.table_for_truncate_length = 50
  config.table_for_truncate_separator = " "
  config.table_for_truncate_omission = "..."
  config.table_for_td_default_prefix_class = "td-item"
end
```
You can also define the breakpoint in your `sass` before importing `table_for`:

```scss
$table-for-breakpoint: 768px;
@import "table_for";
```

### Using an ActiveRecord

The two required fields are: a **Model** and a **collection of ActiveRecord**,
automatically will render all the attributes of the activerecord
For example, by the following way:

```erb
<%= table_for User, @users %>
```


### Using specific fields of the Model

If we want to render specific fields, it is possible to specify the attributes
we want to show by passing the value of `attributes:` as an `Array` inside the
hash `options: {}`.
For example by the following way :

```erb
<%= table_for User, @users options: {attributes: %w(name email tel)} %>
```


### Using helpers

If we want to use helpers to render, it is possible to specify any of the calling methods.

Attributes of the Model have priority in case of having the same name.
This can be done by passing the `options: {}` hash as an `Array`.

For example by the following way:

```erb
<%= table_for User, @users options: {attributes: %w(my_helper_method)} %>

# The helper receives as a parameter the instance of the model.
```


### Using specific fields and actions.

If we want to use buttons for the actions (`:show`, `:edit`, `:destroy`),
it is possible to pass a hash of `actions: {}` to the `options: {}` hash
with the following parameters `actions: {buttons: %w(show edit destroy)}`.

If these actions have a namespace, is required to pass the `premodel:` option
to `actions: {}` as a symbol `Array`:

```erb
<%= table_for User, @users options: {attributes: %w(name email tel), actions: {buttons: %w(show edit destroy), premodel: [:bo, :admin]}} %>
```

#### Actions with text

By default, the corresponent icon is shown for the actions.
But if we only want the text, the following statement must be included in the actions `hash`: `icons: false`.
Additionally, we need to pass the option `icons: true`.

```erb
<%= table_for User, @users, options: {attributes: %w( id type active confirmed_at name surnames email), actions: {buttons: %w(show edit destroy), icons: false, premodel: [:bo, :admin]}} %>
```


#### Custom actions

The system also allows the configuration of custom buttons according to the needs. In order to do it, we must follow a pre-established format: `custom|key1:value1|key2:value2|...`

The possible values are:

* _icons_: boolean, to determine the use of an icon or title option for showing
* _icon_: key name of the icon to be used, for example _eye_, _trash_ o _gear_
* _class_: class to add to the icon
* _title_: allows to add a floating text (tooltip)
* _link_: action link.
* _method_: method of link. You can pass whatever method you want to be used in the link: GET, POST,...
*  _ancestors_: ancestor's object methods to be used to fill up link. Very usefull for nested link generation.

For example:

```erb
table_for(
  User,
  @users,
  options: {
    attributes: %w(id type),
    actions: {
      buttons: "custom|icon:plus|class:btn-success|link:new_page_bo_admin|title:New page",
      premodel: [:bo, :admin]
    }
  }
)

# another example

table_for(
  Comment,
  @comments,
  options: {
    attributes: %w(id),
    actions: {
      buttons: "custom|icons:false|class:btn-error|link:bo_admin|ancestors:communication,user|method:delete|title:Delete comment",
      premodel: [:bo, :admin]
    }
  }
)
```


### With sortable fields

If we want sortered fields, we have to pass the parameter `:sortable` along with the `attribute:` .

For example: `attribute:sortable` It can be done by the following way:

```erb

<%= table_for(
  User,
  @users,
  options: {
    attributes: %w( id:sortable type:sortable name:sortable surnames:sortable),
  }
)
%>
```



### Other options

#### Images

If the attribute is an image and its size is not specified, `thumb` is the default value.

If we want another size, we can pass as a parameter by the following way: `avatar:medium`


#### Nested Model (premodel)

If it is a model which is dependant of another model. For example, we have got a `Chapter` that belongs to `Book`, the routes are polymorphic (for example _book_chapter_path_), we have to pass the option `premodel:` to `actions: {}`.

This option also can be used in routes with namespaces or scopes `premodel:` must be an `Array` of symbols, for example:

```erb
<%= table_for (
  User,
  @users,
  options: {
    attributes: %w(position subtitle),
    actions: {
      buttons: %w(show edit destroy),
      premodel: [:bo, :admin, @book, @chapter]
    }
  }
)
%>
```

#### Attribute with Reference to a Model

If the model `Chapter` that is being represented has an attribute that is a reference
to another model `Book`, we can pass the name of Model's attribute as a referenced
`attributes: {}`, for example `book:name` or `book:isbn` and the table will show name/isbn:

```erb
<%= table_for Chapter, @chapters, options: {attributes: %w(name book:name)} %>
```

#### Attribute with Associations to a Model

If the model `Book` that is being represented has an attribute that is an association to another model `Chapter`, we can pass the name of the association `chapters` as the `attributes: {}` and the table will show the number of related elements.

For example, `<%= table_for Book, @books, options: {attributes: %w(name chapters )}%>`

#### Attribute with parameter `:currency`

If the model `Book` that is being represented has an attribute that is a monetary value `price`, we can pass the parameter `:currency` along with the `attributes: {}` and the table will show the price with the symbol of the currency specified in location files.

For example, `<%= table_for Book, @books, options: {attributes: %w(name price:currency)} %>`

If we want to change the format or symbol, we must modify the corresponding file in the locale. This works for separators and delimiters also.

```yml
en:
  number:
    currency:
      format:
        format: "%n %u"
        unit: "€"
```
#### Attribute with parameter `:percentage`

If the model `Book` that is being represented has an attribute that is a numeric value in percentage `discount`, we can pass the parameter `:percentage` along with the `attributes: {}` and the table will show the price with symbol `%`.

For example, `<%= table_for Book, @books, options: {attributes: %w(name discount:percentage)} %>`

If changing the precision is needed, the file `/config/initializers/ct_table_for.rb` must be created/edited and included:

```rb
CtTableFor.setup do |config|
    config.table_for_numeric_percentage_precision = 2
  end
```

If we want to change the format or symbol, we must modify the corresponding file in the locale.

```yml
en:
  number:
    percentage:
      format:
        format: "%n%"
```

#### Attribute with parameter `:l`

If the model `Book` that is being represented has an attribute `genre` and its value needs to be located, we can pass the parameter `:l` along with the `attributes: {}` and the table will show the located value according to the location files.

For example, `<%= table_for Book, @books, options: {attributes: %w(name type:l genre:l)} %>`

We have to include the translations for the possible values of the corresponding file in locale:

```yml
en:
  activerecord:
    attributes:
      book:
        type: Type
        genre: Genre
      book/type:
        fiction: Fiction
        nonfiction: Non fiction
      book/genre:
        drama: Drama
        scifi: Sci-Fi
        action_and_adventure: Action & adventures
        other: Other
```

#### CSS class and id

Inside the `options: {}` hash we can pass the following:

* `id` (String): will apply to the element `<table>`.
* `class` (String): will apply to the element `<table>`.
* `tr_class` (String): will apply to the element `<table>`.
* `btn_class` (Hash): will apply to the elements `<a>` of the actions along with the value by default of `table_for_default_action_base_class`.

For example:
```erb
<%= table_for(
  User,
  @users,
  options: {
    id: "my-id",
    class: "my-class",
    tr_class: "my-tr-class",
    btn_class: { show: "btn-primary" }
  }
) %>
```

This would be rendered as:

```html
<table id="my-id" class="my-class">
  <tbody>
    <tr class="my-tr-class">
    <td><a class="btn btn-primary"...>...</a></td>
    </tr>
  </tbody>
</table>
```

And its corresponding styles would be applied:

```scss
#my-id{
  border: 2px dashed red;
  .my-class{
    background: aqua;
  }
  .my-tr-class{
    color: deeppink;
  }
}
```
