module V1
  module Validators
    def validate_params_presence(prefix, keys, params)
      keys.each do |key|
        if params[key].blank?
          logger.warn "#{prefix} cancelled (#{key} is required): #{params}"
          return render_error("#{key} is required", 400)
        end
      end
      nil
    end

    def validate_param_length(prefix, key, param, min, max)
      if param.size > max
        logger.warn "#{prefix} cancelled (#{key} should not be more than 20 characters): #{param}"
        return render_error("#{key} should not be more than 20 characters", 400)
      end
      if param.size < min
        logger.warn "#{prefix} cancelled (#{key} should not be less than 5 characters): #{param}"
        return render_error("#{key} should not be less than 5 characters", 400)
      end
      nil
    end

    def validate_param_no_spaces(prefix, key, param)
      if param.match(/\s+/)
        logger.warn "#{prefix} cancelled (#{key} should not contain spaces): #{param}"
        return render_error("#{key} should not contain spaces", 400)
      end
      nil
    end
  end
end