require 'cache_json_requests/version'
require 'cache_json_requests/generator'
require 'action_controller/base'

module CacheJsonRequests
  # Define options
  mattr_reader   :redis
  mattr_accessor :expires_in
  mattr_reader   :cache_namespace
  mattr_reader   :ignore_params
  @@ignore_params ||= false

  # Set Redis connection
  def self.redis=(redis_client)
    @@redis = redis_client
  end

  # Set cache expiration
  def self.expires_in=(seconds)
    @@expires_in = seconds
  end

  # Namespace all cache entries
  def self.cache_namespace=(namespace)
    @@cache_namespace = namespace
  end

  # Whether or not to ignore get parameters when formulating cache
  def self.ignore_params=(boolean)
    @@ignore_params = boolean
  end

  def self.configure
    yield self
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def cache_json_actions(*actions)
      # FIXME options need to be class variables, specific to each controller
      # This can be addressed by extending this module rather than including it
      options = actions.extract_options!
      # if options.has_key?(:expires_in)
      #   self.class_variable_set '@@expires_in', options[:expires_in]
      # end
      # Cache methods defined by the user, otherwise cache everything except [create, update, delete]
      filter_options = actions.empty? ? { except: [:create, :update, :delete] } : { only: actions }
      around_filter :around_json_cache, filter_options
    end
  end

  protected

  def around_json_cache
    # Disregard everything except GET JSON requests
    yield and return unless request.format.json? and request.get?
    # Set cache namespace if appropriate
    key = if @@cache_namespace && @@cache_namespace.present?
            "#{@@cache_namespace}::#{controller_name}:#{action_name}:"
          else
            "#{controller_name}:#{action_name}:"
          end
    # Ignore GET parameters if appropriate
    key << if @@ignore_params
             Zlib.crc32("#{request.protocol}#{request.host_with_port}#{request.fullpath.split('?')[0]}").to_s
           else
             Zlib.crc32("#{request.protocol}#{request.host_with_port}#{request.fullpath}").to_s
           end
    # Check cache for key
    if value = @@redis.get(key)
      render json: JSON.parse(value) and return
    else
      # Run the controller action
      yield
      # If things are going our way, cache the results
      if response.response_code == 200
        if @@expires_in.nil? or @@expires_in.empty?
          # Cache indefinitely since no cache expiration is defined
          @@redis.set key, response.body
        else
          # Cache and set expiration
          @@redis.setex key, @@expires_in, response.body
        end
      end
    end
  end
end

ActionController::Base.send :include, CacheJsonRequests
