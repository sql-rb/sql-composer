# frozen_string_literal: true

RSpec.describe SQL, ".compose" do
  class UsersRelation
    include SQL::Composer::NodeHelpers

    def qualifier
      sql_identifier(:users, backend: SQL::Composer.backends[:postgres])
    end
    alias_method :table, :qualifier

    def id
      sql_identifier(:id, qualifier: qualifier, backend: SQL::Composer.backends[:postgres])
    end

    def name
      sql_identifier(:name, qualifier: qualifier, backend: SQL::Composer.backends[:postgres])
    end
  end

  def build(&block)
    SQL.compose(backend: :postgres, args: UsersRelation.new, &block)
  end

  describe "SELECT" do
    context "without ORDER" do
      specify do
        result = build { |users|
          SELECT users.id, users.name
            FROM users.table
            WHERE users.name == "Jane"
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

    context "with ORDER" do
      specify do
        result = build { |users|
          SELECT users.id, users.name
            FROM users.table
            WHERE users.name == "Jane"
            ORDER users.id.desc
        }

        expect(result.to_s).to eql(
          <<~SQL.strip
          SELECT "users"."id", "users"."name"
          FROM "users"
          WHERE "users"."name" == 'Jane'
          ORDER BY "users"."id" DESC
          SQL
        )
      end
    end
  end
end
