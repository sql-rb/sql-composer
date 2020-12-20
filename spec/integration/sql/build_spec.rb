# frozen_string_literal: true

RSpec.describe SQL, ".build" do
  class UsersRelation
    include SQL::Builder::NodeHelpers

    def table
      sql_identifier(:users)
    end

    def id
      sql_identifier(:id)
    end

    def name
      sql_identifier(:name)
    end
  end

  def build(&block)
    SQL.build(UsersRelation.new, &block)
  end

  it "works" do
    result = build { |users|
      select users.id, users.name
        from users.table
        where users.name == "Jane"
    }

    expect(result.to_s).to eql("SELECT id, name\nFROM users\nWHERE name == 'Jane'")
  end
end
