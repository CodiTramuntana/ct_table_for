module CtTableFor
  class << self
    mattr_accessor :table_for_default_class
    mattr_accessor :table_for_wrapper_default_class
    mattr_accessor :table_for_default_action_base_class
    mattr_accessor :table_for_action_class
    mattr_accessor :table_for_breakpoint
    mattr_accessor :table_for_icon_font_base_class
    mattr_accessor :table_for_action_icons
    mattr_accessor :table_for_numeric_percentage_precision
    mattr_accessor :table_for_cell_for_image_image_class
    mattr_accessor :table_for_truncate_length
    mattr_accessor :table_for_truncate_separator
    mattr_accessor :table_for_truncate_omission
    mattr_accessor :table_for_td_default_prefix_class

    self.table_for_wrapper_default_class = "table-responsive"
    self.table_for_default_class = "table table-striped table-bordered table-condensed table-hover"
    self.table_for_default_action_base_class = "btn btn-sm"
    self.table_for_action_class = {show: "btn-primary", edit: "btn-success", destroy: "btn-danger", other: "btn-default"}
    self.table_for_breakpoint = "992px"
    self.table_for_icon_font_base_class = "fa"
    self.table_for_action_icons = {show: "eye", edit: "pencil", destroy: "trash", custom: "gear"}
    self.table_for_numeric_percentage_precision = 2
    self.table_for_cell_for_image_image_class = "img-responsive"
    self.table_for_truncate_length = 50
    self.table_for_truncate_separator = " "
    self.table_for_truncate_omission = "..."
    self.table_for_td_default_prefix_class = "td-item"
  end

  # this function maps the vars from your app into your engine
  def self.setup(&block)
    yield self
  end

  class Engine < ::Rails::Engine
    isolate_namespace CtTableFor
    paths["app"]

    config.to_prepare do
      ApplicationController.helper(CtTableFor::ApplicationHelper)
    end
  end
end
