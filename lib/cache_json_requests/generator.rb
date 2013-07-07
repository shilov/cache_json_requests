require 'rails/generators'

class CacheJsonRequestsGenerator < Rails::Generators::Base
  def generate_initializer
    # OPTIMIZE move file into template and add comments
    create_file "config/initializers/cache_json_requests.rb",
      "CacheJsonRequests.configure do |config|\n" +
      "  config.redis = Redis.new\n"              +
      "  config.cache_namespace = 'cjr'\n"        +
      "  config.expires_in = 15.minutes\n"        +
      "  # config.ignore_params = false\n"        +
      "end"
  end
end
