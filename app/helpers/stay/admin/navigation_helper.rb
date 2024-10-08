module Stay
  module Admin
    module NavigationHelper
      ICON_SIZE = 14
      MENU_ICON_SIZE = 18

      def tab(*args)
        options = { label: args.first.to_s }

        return '' if (klass = klass_for(args.first.to_s)) && cannot?(:admin, klass)

        options = options.merge(args.pop) if args.last.is_a?(Hash)
        options[:route] ||= "admin_#{args.first}"

        destination_url = options[:url] || stay.send("#{options[:route]}_path")

        if options[:do_not_titleize] == true
          titleized_label = options[:label]
        else
          titleized_label = I18n.t(options[:label], default: options[:label], scope: [:admin, :tab]).titleize
        end

        css_classes = ['sidebar-menu-item d-block w-100 position-relative']

        if (selected = options[:selected]).nil?
          selected = if options[:match_path].is_a? Regexp
                       request.fullpath =~ options[:match_path]
                     elsif options[:match_path]
                       request.fullpath.starts_with?("#{admin_path}#{options[:match_path]}")
                     else
                       args.include?(controller.controller_name.to_sym)
                     end
        end

        link = if options[:icon]
                 link_to_with_icon(
                   options[:icon],
                   titleized_label,
                   destination_url,
                   class: 'w-100 px-3 py-2 d-flex align-items-center text-muted',
                   width: MENU_ICON_SIZE,
                   height: MENU_ICON_SIZE
                 )
               else
                 link_to(
                   titleized_label,
                   destination_url,
                   class: "sidebar-submenu-item w-100 py-2 py-md-1 pl-5 d-block #{selected ? 'font-weight-bold' : 'text-muted'}"
                 )
               end

        css_classes << 'selected' if selected

        css_classes << options[:css_class] if options[:css_class]
        content_tag('li', link, class: css_classes.join(' '))
      end

      def klass_for(name)
        model_name = name.to_s

        ["Stay::#{model_name.classify}", model_name.classify, model_name.tr('_', '/').classify].find(&:safe_constantize).try(:safe_constantize)
      end

      def link_to_edit(resource, options = {})
        url = options[:url] || edit_object_url(resource)
        options[:data] = { action: 'edit' }
        options[:class] = 'btn btn-light btn-sm'
        link_to_with_icon('edit.svg', I18n.t(:edit), url, options)
      end

      def link_to_edit_url(url, options = {})
        options[:data] = { action: 'edit' }
        options[:class] = 'btn btn-light btn-sm'
        link_to_with_icon('edit.svg', I18n.t(:edit), url, options)
      end

      def link_to_delete(resource, options = {})
        url = options[:url] || object_url(resource)
        name = options[:name] || I18n.t(:delete)
        options[:class] = 'btn btn-danger btn-sm delete-resource'
        options[:data] = { confirm: I18n.t(:are_you_sure), action: 'remove' }
        link_to_with_icon 'delete.svg', name, url, options
      end
    end
  end
end
