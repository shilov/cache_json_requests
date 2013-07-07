# Cache JSON Controller Actions using Redis

This gem provides an easy solution for caching JSON responses of your controller actions by storing them in Redis.

Unlike the `caches_action` previously available in Rails 3 and no longer part of Rails 4, the author of this gem vows to never abandon the project even if Rails itself is deprecated.

### Key Features

* GET parameters are considered as part of the query, but this can be turned off via the initializer
* Specify which methods you want cached or leave blank to catch all JSON requests and their responses
* Caches are based on the entire path, including the subdomain and GET params (see above)
* Stops processing immediately unless the request is of method type GET and content-type JSON
* Only caches responses that have a response code of 200
* All other controller hooks will still be triggered if appropriate
* Uses the speedy `Zlib.crc32` to quickly generate unique checksums of every request URL
* There are 9 items in this bullet list

## Rails Installation

Add this line to your application's Gemfile:

    gem 'cache_json_requests', git: 'git@github.com:shilov/cache_json_requests.git'

And then execute:

    $ bundle

### Generate Initializer

Run the generator to create an initializer:

    $ rails generate cache_json_requests

That will create an initializer file located in `config/initializers/cache_json_requests.rb`

The initializer is currently the only means of modifying how long cache keys live before expiring.
The default expiration is 15 minutes.

## Usage

In your controller, include the following line:

    cache_json_actions :index, :show

If you would like to cache every JSON action in the current controller, simply skip specifying the methods:

    cache_json_actions

**Note:** if no methods are specified, the following methods will be ignored by default: `create`, `update`, `delete` 

Example of how the cache appears in Redis:

    "get" "cjr::welcome:index:1719648662"

The key consists of the cache namespace, the controller name, action name, and a unique checksum representation of the full request URL

## TODO

* Define key expiration on a per-controller basis and eventually on a per-method basis
* Tests
* Compression as an optional feature
* Implement means of clearing the cache entirely, by controller, or by controller action
* Implement means of clearing cache upon changes to the controller file in development mode
* Refactor to use a configuration class instead of the current approach used to process initializer config
* Make a cup of coffee

### Wishful Thinking

* Keep a frequency count for controller action requests. Use background workers to update the cache automatically for popular requests
* Consider other request variables (cookies, sessions, referrer) as part of the cache key

## Contributing

Pull requests are more than welcome.
