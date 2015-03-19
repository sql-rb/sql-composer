# SQL.rb (WIP/PoC)

A set of tools to generate SQL using AST transformations.

The goal of this project is to provide a foundation for generating SQL that is
reusable for other Ruby libraries that need to translate their SQL-representation
into SQL strings.

The idea is that SQL.rb ships with its own AST and a couple of tools to help
working with this AST.

In example ActiveRecord **could do this**:

``` ruby
ar_ast = User.select(:id, :name).where(name: 'Jane').to_ast
# s(:select,
#   s(:fields, :id, :name),
#   s(:from, 'users'),
#   s(:where,
#     s(:name, s(:eq, 'Jane'))
#   )
# )

sql_ast = ActiveRecord::SQL.call(User, ar_ast)
# s(:select,
#   s(:fields,
#     s(:id, 'id'), s(:id, 'name')
#   ),
#   s(:id, 'users'),
#   s(:where,
#     s(:eq, s(:id, 'name'), s(:string, 'Jane'))
#   )
# )

SQL[sql_ast]
# => SELECT "id", "name" FROM "users" WHERE "name" = 'Jane'
```

This project is in a PoC state and is heavily based on the experience and actual
code written initially for [ROM](https://github.com/rom-rb), specifically:

* [dkubb/sql](https://github.com/dkubb/sql) - ast-based pure sql generator/parser
* [solnic/axiom-sql-generator](https://github.com/solnic/axiom-sql-generator) - which was an attempt to translate axiom ast into sql ast
* a ton of ast-processing-related work done by [mbj](https://github.com/mbj) for unparser and mutant gems

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sql.rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sql.rb

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/solnic/sql.rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
