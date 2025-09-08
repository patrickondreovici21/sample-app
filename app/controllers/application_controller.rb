class ApplicationController < ActionController::Base
    include SessionsHelper
    include Pagy::Backend
    rescue_from Pagy::OverflowError, with: :redirect_to_last_page

    private
        def logged_in_user
            unless logged_in?
                flash[:danger] = "Please log in."
                redirect_to login_url, status: :see_other
            end
        end

        def redirect_to_last_page
            redirect_to url_for(page: 1)
        end
end
