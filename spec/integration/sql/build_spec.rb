# frozen_string_literal: true

RSpec.describe SQL, ".build" do
  class UsersRelation
    include SQL::Builder::NodeHelpers

    def qualifier
      sql_identifier(:users, backend: SQL::Builder.backends[:postgres])
    end
    alias_method :table, :qualifier

    def id
      sql_identifier(:id, qualifier: qualifier, backend: SQL::Builder.backends[:postgres])
    end

    def name
      sql_identifier(:name, qualifier: qualifier, backend: SQL::Builder.backends[:postgres])
    end
  end

  def build(&block)
    SQL.build(backend: :postgres, args: UsersRelation.new, &block)
  end

  it "works" do
    result = build { |users|
      select users.id, users.name
        from users.table
        where users.name == "Jane"
    }

    expect(result.to_s).to eql(
      <<~SQL.strip
      SELECT "users"."id", "users"."name"
      FROM "users"
      WHERE "users"."name" == 'Jane'
      SQL
    )
  end
end
