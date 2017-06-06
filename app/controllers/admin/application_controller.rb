# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    http_basic_authenticate_with(
      name: ENV.fetch('ADMIN_NAME', 'admin'),
      password: ENV.fetch('ADMIN_PASSWORD', 'admin')
    )

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
    def index
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
        show_search_bar: show_search_bar?,
      }
    end

    private

    def resources
      r = Administrate::Search.new(resource_resolver, search_term).run
      r = order.apply(r)
      r.page(params[:page]).per(records_per_page)
    end

    def search_term
      params[:search].to_s.strip
    end
  end
end
