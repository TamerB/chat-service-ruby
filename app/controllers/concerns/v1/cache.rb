module V1
  module Cache
    module RedisCache
      extend ActiveSupport::Concern

      # read_cache gets entry from cache
      def read_cache(key)
        Rails.cache.read(key)
      end

      # remove_cache removes entry from cache
      def remove_cache(key)
        Rails.cache.delete(key)
      end

      # write_cache writes entry into cache
      def write_cache(key, value)
        Rails.cache.write(key, value)
      end

      # remove_cache_pattern removes all matches of passed pattern
      def remove_cache_pattern(pattern)
        Rails.cache.delete_matched(pattern)
      end
    end
  end
end
