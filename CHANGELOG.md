# Changelog

## version 1.0.4 to be released

- ...

## version 1.0.3 to

- fix allow currency and sortable attributes work together

## version 1.0.2

- fix application of ability model on record actions

## version 1.0.1

- fix table headers for associated model with ransack

## version 0.1.13.beta

- added whole row clikable link as an option

## version 0.1.12.beta

- added option to don't truncate cell strings, passing `:no_truncate` as an attribute parameter
- added settings option to change trucate defaults such as `separator`, `length` and `omission`

## version 0.1.11.beta

- added `localized` table cell, passing :l as an attribute parameter

## version 0.1.10.beta

- fix table_for_cell_for_image_image_class in helper

## version 0.1.9.beta

- removed `.capitalize` from `human_attribute_name("#{attribute}")`
- added `percentage numeric_type cell` with `configurable precision decimals`
- changed `PaperClip class defintion` with `Paperclip class defintion`
- added `setting image class` with `configurable class`

## version 0.1.8.beta

- added Changelog.md
- removed dependencies:
  - Bootstrap
  - Fontawesome
  - include media
- use `human_attribute_name` for attributes translations
- check if Ransack is defined to apply `sort_link`
- table_for optional settings in initializer
- table_for configurable breakpoint
- when attibute is an association and no asssciation attribute specified try title or name
- customizable icon font and action icons
- cell differentaite `Time` and `TimeWithZone`
- `Numeric` with option `:currency` to format with `number_to_currency`
