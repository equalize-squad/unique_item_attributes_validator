# unique_item_attributes_validator

A simple validator to verify the uniqueness of certain attributes from a collection.
Should be compatible with all latest Rubies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "unique_item_attributes_validator"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unique_item_attributes_validator

## Usage

Let's say you've got a simple hero model:

```ruby
class Hero
  include ActiveModel::Validations

  attr_accessor :alter_ego, :name, :superpower

  def initialize(alter_ego:, name:, superpower:)
    @alter_ego = alter_ego
    @name = name
    @superpower = superpower
  end
end
```

And you want to form a super team with a collection of heroes. Then..

```ruby
class SuperTeam
  include ActiveModel::Validations

  attr_accessor :heroes

  def initialize(heroes:)
    @heroes = heroes
  end
end
```

But the `alter_ego` and the `name` attributes must be unique for the heroes of this collection. So..

```ruby
class SuperTeam
  include ActiveModel::Validations

  attr_accessor :heroes

  def initialize(heroes:)
    @heroes = heroes
  end

  validates :heroes, unique_item_attributes: [:alter_ego, :name] #YAY!
end
```

And that's pretty much it! 😁

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/equalize-squad/unique_item_attributes_validator.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
