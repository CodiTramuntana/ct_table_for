# Changelog

# Changelog
## version 1.2.1

- Polymorphic path now casts route into a symbol (prevents error on Rails 6)
## version 1.2.0

- Add _target_ option to custom actions
- Rework README documentation

## version 1.1.0

- Upgrade to Rails 6.1
- [FEATURE] Change style given a method (#25)
- Remove comma separator enforcer
- Force locale settings on numbers
- Add documentation
- Add comma separator option to numbers

## version 1.0.5

- Delete rails 5 restriction (#22)

## version 1.0.4

- Add class to td, for custom styles

## version 1.0.3

- Fix allow currency and sortable attributes work together
- Fix display format of data time 

## version 1.0.2

- Fix application of ability model on record actions

## version 1.0.1

- Fix table headers for associated model with ransack

## version 0.1.13.beta

- Add whole row clikable link as an option

## version 0.1.12.beta

- Add option to don't truncate cell strings, passing `:no_truncate` as an attribute parameter
- added settings option to change trucate defaults such as `separator`, `length` and `omission`

## version 0.1.11.beta

- Add `localized` table cell, passing :l as an attribute parameter

## version 0.1.10.beta

- Fix table_for_cell_for_image_image_class in helper

## version 0.1.9.beta

- Remove `.capitalize` from `human_attribute_name("#{attribute}")`
- Add `percentage numeric_type cell` with `configurable precision decimals`
- Change `PaperClip class defintion` with `Paperclip class defintion`
- Add `setting image class` with `configurable class`

## version 0.1.8.beta

- Add Changelog.md
- Remove dependencies:
  - Bootstrap
  - Fontawesome
  - include media
- Use `human_attribute_name` for attributes translations
- Check if Ransack is defined to apply `sort_link`
- Table_for optional settings in initializer
- Table_for configurable breakpoint
- Try title or name when attibute is an association and no asssciation attribute specified
- Customizable icon font and action icons
-  Differentiate `Time` and `TimeWithZone` cells
- `Numeric` with `:currency` option to format with `number_to_currency`
