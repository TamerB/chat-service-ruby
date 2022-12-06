module V1::ErrorResponses
    module Response
        extend ActiveSupport::Concern
        
        def render_error(message, code)
            @message = message
            @code = code
            render "v1/error", status: @code
        end
    end
end