module CtTableFor
  module ApplicationHelper
    require 'uri'

    ####################################################################################
    # RWD Table
    # use as: table_for Model, @collection, options: {}
    # options: {
    #   actions: {
    #     buttons: %w(show, edit)},          // Hash: with array of buttons for actions
    #     premodel: [:bo, :admin],           // Array: of symbols for nested namespaces/models
    #     icons: true                        // Boolean: if true show actions as icons
    #   }
    #   attributes: %(name:sortable email),  // Array: of model attibutes to show in table
    #                                        // with extra parameter `:` add cell options (sort, image size)
    #                                        // if the attribute is a relation pass the attribute to show
    #                                        // if the attribute has an association will show a number with the count
    #   id: "my-id",                         // String: adds custom id to <table> element
    #   class: "my-custom-css",              // String: add custom class to <table> element
    #   tr_class: "my-custom-css"            // String: add custom class to <tr> element
    #   btn_class: {                         // Hash: add custom class to action buttons
    #     show: "my-custom-css",
    #     edit: "my-custom-css"
    #   }
    #  clickable: true || Array              // Boolean or Array of nested resources for polymorphic_url
    #}
    ####################################################################################

    def table_for model, collection, options: {}
      custom_id = options[:id].present? ? %Q{id="#{options[:id]}"} : ""
      html = %Q{<div class="table-for-wrapper #{CtTableFor.table_for_wrapper_default_class}">}
        html << %Q{<table #{custom_id} class="table-for #{CtTableFor.table_for_default_class} #{options[:class]} #{("table-clickable") if options[:clickable]}">}
          html << table_for_header(model, has_actions: options[:actions].present?, options: options)
          html << table_for_content(model, collection, options: options)
        html << %Q{</table>}
      html << %Q{</div>}
      html.html_safe
    end

    def table_for_attributes model, options
      options[:attributes] || model.attribute_names
    end

    def table_for_header model, has_actions: false, options: {}
      html = ""
      html << %Q{<thead>}
        html << %Q{<tr>}
          table_for_attributes(model, options).each do |attribute|
            html << %Q{<th>}
              attribute, *params = attribute.split(":")
              html << if defined?(Ransack) and params.include? "sortable"
                if params.length > 1 && !params.include?("l")
                  sort_link(@q, "#{attribute}_#{params.first}", I18n.t("#{attribute.to_s.underscore}_#{params.first}", scope: [:activerecord, :attributes, model.to_s.underscore]).capitalize )
                else
                  sort_link(@q, attribute, I18n.t("#{attribute}", scope: [:activerecord, :attributes, model.to_s.underscore]).capitalize )
                end
              else
                model.human_attribute_name("#{attribute}")
              end
            html << %Q{</th>}
          end
          html << %Q{<th class="actions">#{I18n.t(:actions, scope: [:table_for]).capitalize}</th>} if has_actions
        html << %Q{</tr>}
      html << %Q{</thead>}
      html.html_safe
    end

    def table_for_content model, collection, options: {}
      html = ""
      html << %Q{<tbody>}
        if collection.present?
          custom_tr_class = options[:tr_class].present? ? %Q{class="#{options[:tr_class]}"} : ""
          collection.each do |record|
            html << %Q{<tr data-colection-id="#{record.try(:id)}" #{custom_tr_class} #{row_data_link(record, options)}>}
              table_for_attributes(model, options).each do |attribute|
                attribute, *params = attribute.split(":")
                html << table_for_cell( model, record, attribute, cell_options: params )
              end
              html << table_for_actions( record, options: options) if options[:actions].present?
            html << %Q{</tr>}
          end
        else
          html << %Q{<tr>}
            html << %Q{<td colspan=#{options[:attributes].size + 1}>}
              html << I18n.t("table_for.messages.no_records")
            html << %Q{</td>}
          html << %Q{</tr>}
        end
      html << %Q{</tbody>}
      html.html_safe
    end

    def row_data_link(record, options)
      return unless options[:clickable]
      if options[:clickable].kind_of?(Array)
        nested_resources = (options[:clickable] || []) + [record]
      else
        nested_resources = record
      end
      "data-link =" << polymorphic_url(nested_resources)
    end

    def table_for_cell model, record, attribute, cell_options: {}
      html = ""
      value = if record.respond_to?(attribute.to_sym)
                record.send(attribute.to_sym)
              elsif self.respond_to?(attribute.to_sym)
                self.send(attribute.to_sym, record)
              else
                nil
              end

      html << %Q{<td data-title="#{model.human_attribute_name("#{attribute}")}">}
        case value
        when NilClass
          html << %Q{<i class="fa fa-minus text-muted"></i>}
        when TrueClass, FalseClass
          html << %Q{<i class="fa #{value ? "fa-check text-success" : "fa-times text-danger"}"></i>}
        when Numeric
          if cell_options.include? "currency"
            html << number_to_currency(value)
          elsif cell_options.include? "percentage"
            html << number_to_percentage(value, precision: CtTableFor.table_for_numeric_percentage_precision)
          else
            html << %Q{<code>#{value}</code>}
          end
        when ActiveSupport::TimeWithZone
          # TODO: value.in_time_zone
          html << %Q{<code>#{value.strftime("%d/%m/%Y %H:%M:%S")}</code>}
        when Time
          # TODO: value.in_time_zone
          html << %Q{<code>#{value.strftime("%H:%M:%S")}</code>}
        when ActiveRecord::Base
          if cell_options.present?
            if defined?(Paperclip) and (value.send cell_options[0]).is_a?(Paperclip::Attachment)
              html << table_for_cell_for_image( value, cell_options[0], cell_options: cell_options )
            else
              html << %Q{#{value.send cell_options[0]}}
            end
          else
            html << %{#{(value.try(:title) || value.try(:name))}}
          end
        when ActiveRecord::Associations::CollectionProxy
          html << %Q{#{value.count}}
        else
          if uri?(value)
            html << link_to(value, value)
          elsif defined?(Paperclip) and value.is_a?(Paperclip::Attachment)
            html << table_for_cell_for_image( record, attribute, cell_options: cell_options )
          else
            if cell_options.include? "l"
              html << table_for_cell_for_locale(model, attribute, value)
            elsif cell_options.include? "no_truncate"
              html << value.to_s
            else
              html << value.to_s.truncate(
                CtTableFor.table_for_truncate_length,
                separator: CtTableFor.table_for_truncate_separator,
                omission: CtTableFor.table_for_truncate_omission
              )
            end
          end
        end
      html << %Q{</td>}
      html.html_safe
    end

    def table_for_cell_for_image record, attribute, cell_options: {}
      html = ""
      size = cell_options.select{ |opt| ["thumb", "original", "small", "medium"].include? opt }.first || "thumb"

      html << image_tag(record.send(attribute).url(size), class: CtTableFor.table_for_cell_for_image_image_class, style: "max-height: 100px;")
      html.html_safe
    end

    def table_for_cell_for_locale model, attribute, value, cell_options: {}
      html = model.human_attribute_name("#{attribute.underscore}.#{value.underscore}")
    end


    def table_for_actions(record, options: {} )
      return "" if options[:actions].blank?
      html = ""
      html << %Q{<td data-link-enabled="false">}
        html << %Q{<div class="btn-group btn-group-sm" role="group" aria-label="#{I18n.t(:actions, scope: [:table_for]).capitalize}">}
        nesting = (options[:actions][:premodel] || []) + [record]
        buttons = options[:actions][:buttons].map{ |b| b.split("|")}
        buttons.each do |action, *extras|
          return "" if defined?(CanCanCan) and cannot?(action, record)
          case action.to_sym
          when :show
            html << link_to(label_for_action(action, options[:actions][:icons]).html_safe, polymorphic_path(nesting), class: class_for_action(action, options))
          when :edit
            html << link_to(label_for_action(action, options[:actions][:icons]).html_safe, edit_polymorphic_path(nesting), class: class_for_action(action, options))
          when :destroy
            html << link_to(label_for_action(action, options[:actions][:icons]).html_safe, polymorphic_path(nesting),
                            method: :delete, class: class_for_action(action, options), data: { confirm: I18n.t('table_for.messages.are_you_sure').capitalize })
          when :custom
            html << button_for_custom_action(record, options, extras)
          else
            # TODO:
            # nesting_custom = nesting + btn_options[0]
            # label = icon CtTableFor.table_for_action_icons[:custom] if options[:actions][:icons] != false and defined?(FontAwesome)
            # html << link_to(label, polymorphic_path(nesting_custom), class: "btn btn-default btn-sm")
          end
        end
        html << %Q{</div>}
      html << %Q{</td>}
      html.html_safe
    end

    def label_for_action action, icons = true
      label = I18n.t(action.to_sym, scope: [:table_for, :buttons]).capitalize
      if icons != false
        label = %Q{<i class="#{CtTableFor.table_for_icon_font_base_class} #{CtTableFor.table_for_icon_font_base_class}-#{CtTableFor.table_for_action_icons[action.to_sym]}"></i>}
      end
      label
    end

    def class_for_action action, options
      %Q{#{CtTableFor.table_for_default_action_base_class} #{options.dig(:btn_class, action.to_sym) || CtTableFor.table_for_action_class[action.to_sym]}}
    end

    def button_for_custom_action record, options, extras
      parsed_extras = parse_extras(extras)
      # `icons` is a Boolean-String option to limit `icon` option
      label = if parsed_extras[:icons].to_s == "false"
        parsed_extras[:title].presence || ""
      else
        %Q{<i class="#{CtTableFor.table_for_icon_font_base_class} #{CtTableFor.table_for_icon_font_base_class}-#{parsed_extras[:icon]}"></i>}
      end
      ancestors_list = parsed_extras[:ancestors].presence || ""
      ancestors = ancestors_list.split(",").map do |ancestor|
        record.send(ancestor)
      end
      custom_action_class = %Q{#{CtTableFor.table_for_default_action_base_class} #{parsed_extras[:class]}}
      link_to(label.html_safe,
              polymorphic_path([parsed_extras[:link], *ancestors, record]),
              class: custom_action_class,
              method: parsed_extras[:method],
              title: parsed_extras[:title])
    end

    def uri?(string)
      # http://ruby-doc.org/stdlib-2.4.0/libdoc/uri/rdoc/URI.html
      uri = URI.parse(string)
      %w( http https ).include?(uri.scheme)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
    end

    def parse_extras(extras)
      Hash[extras.collect { |extra| [extra.split(":").first, extra.split(":").last] } ].with_indifferent_access
    end
  end
end
