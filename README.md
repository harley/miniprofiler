# NOTE FOR THIS GEM FORK

This is a fork the Ruby folder of https://github.com/SamSaffron/MiniProfiler which includes some quick fixes to make the original rack-mini-profiler gem a little more usable. I will consolidate any useful changes here into pull requests for the original repo.

* Add `gem 'miniprofiler'` to your Gemfile (install of 'rack-mini-profiler')
* `miniprofiler`'s version uses `x.y.z.t` syntax in order to more easily sync with `rack-mini-profiler`'s `x.y.z` SemVer versioning. I will increase `t` whenever I make a patch
* This gem fork will work in staging, not just development and production
* Gem release date will be correct (as of now 'rack-mini-profiler' hardcodes the release date to be 04/02/2012, which is very confusing: https://rubygems.org/gems/rack-mini-profiler -- I will report to them)
* Allow turning off loading jquery if the app already uses jquery
* More to come

# Original README below:

# rack-mini-profiler

Middleware that displays speed badge for every html page. Designed to work both in production and in development.

## Using rack-mini-profiler in your app

Install/add to Gemfile

```ruby
gem 'rack-mini-profiler'
```
Using Rails:

All you have to do is include the Gem and you're good to go in development.

rack-mini-profiler is designed with production profiling in mind. To enable that just run `Rack::MiniProfiler.authorize_request` once you know a request is allowed to profile.

For example:

```ruby
# A hook in your ApplicationController
def authorize
  if current_user.is_admin?
    Rack::MiniProfiler.authorize_request
  end
end
````


Using Builder:

```ruby
require 'rack-mini-profiler'
builder = Rack::Builder.new do
  use Rack::MiniProfiler

  map('/')    { run get }
end
```

Using Sinatra:

```ruby
require 'rack-mini-profiler'
class MyApp < Sinatra::Base
  use Rack::MiniProfiler
end
```

## Storage

By default, rack-mini-profiler stores its results in a memory store:

```ruby
# our default
Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
```

There are 2 other available storage engines, `RedisStore` and `FileStore`.

MemoryStore is stores results in a processes heap - something that does not work well in a multi process environment.
FileStore stores results in the file system - something that may not work well in a multi machine environment.

Additionally you may implement an AbstractStore for your own provider.

Rails hooks up a FileStore for all environments.

## Running the Specs

```
$ rake build
$ rake spec
```

Additionally you can also run `autotest` if you like.

## Configuration Options

You can set configuration options using the configuration accessor on Rack::MiniProfiler:

```
# Have Mini Profiler show up on the right
Rack::MiniProfiler.config.position = 'right'
```

In a Rails app, this can be done conveniently in an initializer such as config/initializers/mini_profiler.rb.

## Available Options

* pre_authorize_cb - A lambda callback you can set to determine whether or not mini_profiler should be visible on a given request. Default in a Rails environment is only on in development mode. If in a Rack app, the default is always on.
* position - Can either be 'right' or 'left'. Default is 'left'.
* skip_schema_queries - Whether or not you want to log the queries about the schema of your tables. Default is 'false', 'true' in rails development.

## Special query strings

If you include the query string `pp=help` at the end of your request you will see the various option you have. You can use these options to extend or contract the amount of diagnostics rack-mini-profiler gathers.

