# Changelog

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