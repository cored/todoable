# Todoable

Wrapper for the Todoable API

[![Maintainability](https://api.codeclimate.com/v1/badges/2e46f4fbc22fc4170fdc/maintainability)](https://codeclimate.com/github/cored/todoable/maintainability)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'todoable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install todoable

## Usage

```
require "todoable"
```

### Authentication

```
client = Todoable.authenticate!(username: <your_username>, password: <your_password>)
```

### Retrieve lists

```
client.lists
=> #<Todoable::Resources::Lists lists=[
  #<Todoable::Resources::List
    name="My new List"
    id="7ad41da8-1e81-4636-ae7f-5f2905974c31"
    src="http://todoable.teachable.tech/api/lists/7ad41da8-1e81-4636-ae7f-5f2905974c31">,
  #<Todoable::Resources::List
    name="Testing List"
    id="929bda84-b2e2-459f-b62d-4d76f58e96f0"
    src="http://todoable.teachable.tech/api/lists/929bda84-b2e2-459f-b62d-4d76f58e96f0">]>
```

### Retrieve a single list

```
list = client.create_list!(name: "For single retrieval")
client.list(id: list.id)
=> #<Todoable::Resources::List name="For single retrieval" id=nil src=nil>
```


### Create a list

```
Todoable.create_list!(name: "my_new_list")
=> #<Todoable::Resources::List
      name="For the readme"
      id="1e87973c-61b3-42ce-8e2c-e3021b1d4500"
      src="http://todoable.teachable.tech/api/lists/1e87973c-61b3-42ce-8e2c-e3021b1d4500">
```

### Delete a list

```
list = client.list.find_by(name: "For the readme")
Todoable.delete_list!(id: list.id)
=> #<Todoable::Client:0x00007fe23d02de70 ...>
```

### Create a todo item

```
list = client.lists.first
client.create_item!(list_id: list.id, name: "My new item")
=> #<Todoable::Resources::Item
      name="My new item"
      id="69bf4828-2cb4-4f96-bced-37fa928c8fb2"
      src="http://todoable.teachable.tech/api/lists/7ad41da8-1e81-4636-ae7f-5f2905974c31/items/69bf4828-2cb4-4f96-bced-37fa928c8fb2"
      finished_at=nil>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cored/todoable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Todoable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cored/todoable/blob/master/CODE_OF_CONDUCT.md).
