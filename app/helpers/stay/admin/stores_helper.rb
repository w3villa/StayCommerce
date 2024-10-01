module Stay
  module Admin
    module StoresHelper
      def stores_dropdown_values
        formatted_stores = []

        @stores.map { |store| formatted_stores << [store.unique_name, store.id] }

        formatted_stores
      end

      def store_switcher_link(store)
        if current_store.id == store.id
          classes = 'disabled bg-light'
          icon = svg_icon name: 'circle-fill.svg', width: '18', height: '18'
        else
          classes = nil
          icon = svg_icon name: 'circle.svg', width: '18', height: '18'
        end
        url = store.default? ? '#' : set_default_admin_store_path(store)
        button_to icon + store.unique_name, url, method: :put, class: "#{classes} py-3 px-4 dropdown-item rounded", id: store.code, form: { data: { turbo: false } }
      end
    end
  end
end
