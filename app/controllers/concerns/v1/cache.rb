module V1::Cache
    module RedisCache
        extend ActiveSupport::Concern

        def read_cache(key)
            Rails.cache.read(key)
        end

        def remove_cache(key)
            Rails.cache.delete(key)
        end

        def write_cache(key, value)
            Rails.cache.write(key, value)
        end

        def remove_cache_pattern(pattern)
            begin
                Rails.cache.delete_matched(pattern)
            rescue => e
                puts e.message
            end
        end
    end
end