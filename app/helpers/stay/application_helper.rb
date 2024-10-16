module Stay
  module ApplicationHelper
    include CurrencyHelper
    include Stay::Admin::SortableTreeHelper
    include Stay::Admin::NavigationHelper
      ICON_SIZE = 14

    def svg_icon(name:, classes: '', width:, height:)
      if name.ends_with?('.svg')
        icon_name = File.basename(name, File.extname(name))
        inline_svg_tag "#{icon_name}.svg", class: "icon-#{icon_name} #{classes}", size: "#{width}px*#{height}px"
      else
        inline_svg_tag "#{name}.svg", class: "icon-#{name} #{classes}", size: "#{width}px*#{height}px"
      end
    end

    def active_badge(condition, options = {})
      label = options[:label]
      label ||= condition ? I18n.t('admin.say_yes') : I18n.t('admin.say_no')
      css_class = condition ? 'badge-active' : 'badge-inactive'

      content_tag(:small, class: "badge badge-pill #{css_class}") do
        label
      end
    end

    def link_to_with_icon(icon_name, text, url, options = {})
      options[:class] = (options[:class].to_s + " icon-link with-tip action-#{icon_name}").strip
      options[:title] = text if options[:no_text]
      text = options[:no_text] ? '' : content_tag(:span, text)
      options.delete(:no_text)
      options[:width] ||= ICON_SIZE
      options[:height] ||= ICON_SIZE
      if icon_name
        icon = if icon_name.ends_with?('.svg')
                 svg_icon(name: icon_name, classes: "#{'mr-2' unless text.empty?} icon icon-#{icon_name}", width: options[:width], height: options[:height])
               else
                 content_tag(:span, '', class: "#{'mr-2' unless text.empty?} icon icon-#{icon_name}")
               end
        text = "#{icon} #{text}"
      end
      link_to(text.html_safe, url, options)
    end

    def button_to_with_icon(icon_name, text, url, options = {})
      options[:class] = (options[:class].to_s + " icon-link with-tip action-#{icon_name}").strip
      options[:title] = text if options[:no_text]
      text = options[:no_text] ? '' : content_tag(:span, text)
      options.delete(:no_text)
      options[:width] ||= ICON_SIZE
      options[:height] ||= ICON_SIZE

      if icon_name
        icon = if icon_name.ends_with?('.svg')
                 svg_icon(name: icon_name, classes: "#{'mr-2' unless text.empty?} icon icon-#{icon_name}", width: options[:width], height: options[:height])
               else
                 content_tag(:span, '', class: "#{'mr-2' unless text.empty?} icon icon-#{icon_name}")
               end
        text = "#{icon} #{text}".html_safe
      end

      button_to(text, url, options)
    end
  end
end
