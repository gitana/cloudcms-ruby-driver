# Cloudcms

Cloud CMS Ruby Driver

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudcms'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloudcms

## Usage
```
    #!/usr/bin/env ruby
    require 'cloudcms'

    cloudcms = Cloudcms::Cloudcms.new()
    platform = cloudcms.connect()
    puts "connected to api server at: #{cloudcms.config['baseURL']}"
    # puts 'platform: ' + JSON.pretty_generate(platform.data)
    puts "platform id: #{platform.data['_doc']}"

    repositories = platform.list_repositories
    # puts 'list_repositories: ' + JSON.pretty_generate(repositories)

    repository = platform.read_repository(repositories[0].data["_doc"])
    # puts 'read_repository: ' + JSON.pretty_generate(repository.data)

    branches = repository.list_branches
    # puts 'branches: ' + JSON.pretty_generate(branches[0].data)
    branch = repository.read_branch(branches[0].data["_doc"])

    nodes = branch.query_nodes({_type: 'n:node'}, {limit: 5})
    node = branch.read_node(nodes[0]["_doc"])
    puts 'node: ' + JSON.pretty_generate(node.data)
```

## Run Test Script
bundle exec ruby api-call-driver.rb

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cloudcms.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
