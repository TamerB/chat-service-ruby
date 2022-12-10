module V1
  module ErrorResponses
    module Response
      extend ActiveSupport::Concern
      def render_error(message, code)
        @message = message
        @status = code
        render 'v1/error', status: @status
      end

      def render_internal_error(message)
        logger.error message
        render_error('Something went wrong. please try again later', 500)
      end
    end
  end
end
