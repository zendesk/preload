# Preload [![CI status](https://github.com/zendesk/preload/actions/workflows/ci.yml/badge.svg)](https://github.com/zendesk/preload/actions/workflows/ci.yml)

Allows you to split your ActiveRecord find calls and your eager loading decisions.

## Installation

```
gem install preload
```

## Usage

Now in your controller you don't have to know which associations should be eager loaded because your views need them.

### In your controller:

```ruby
def index
  @posts = blog.posts.order('created_at DESC')
end
```

### in your view:
```
  <% @posts.pre_load(:comments) %>
  ... render posts and their comments ...
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Releasing a new version
A new version is published to RubyGems.org every time a change to `version.rb` is pushed to the `main` branch.
In short, follow these steps:
1. Update `version.rb`,
2. update version in all `Gemfile.lock` files,
3. merge this change into `main`, and
4. look at [the action](https://github.com/zendesk/preload/actions/workflows/publish.yml) for output.

To create a pre-release from a non-main branch:
1. change the version in `version.rb` to something like `1.2.0.pre.1` or `2.0.0.beta.2`,
2. push this change to your branch,
3. go to [Actions → “Publish to RubyGems.org” on GitHub](https://github.com/zendesk/preload/actions/workflows/publish.yml),
4. click the “Run workflow” button,
5. pick your branch from a dropdown.
