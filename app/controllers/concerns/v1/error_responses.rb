module V1::ErrorResponses
    module Response
        extend ActiveSupport::Concern
        
        def render_error(message, code)
            @message = message
            @code = code
            render :error, status: @code
        end
end
end