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

  def compose(&block)
    SQL.compose(backend: :postgres, args: UsersRelation.new, &block)
  end

  let(:result) do
    query.to_s
  end

  describe "SELECT" do
    context "with literals" do
      let(:query) do
        compose {
          SELECT `"users"."id"`, `"users"."name"`
          FROM `"users"`
        }
      end

      specify do
        expect(result).to eql(
          <<~SQL.strip
            SELECT "users"."id", "users"."name"
            FROM "users"
          SQL
        )
      end
    end

    context "inline syntax" do
      let(:query) do
        compose {
          SELECT(`"users"."id"`, `"users"."name"`).FROM(`"users"`)
        }
      end

      specify do
        expect(result).to eql(
          <<~SQL.strip
            SELECT "users"."id", "users"."name"
            FROM "users"
          SQL
        )
      end
    end

    context "without WHERE" do
      let(:query) do
        compose { |users|
          SELECT users.id, users.name
          FROM users.table
        }
      end

      specify do
        expect(result.to_s).to eql(
          <<~SQL.strip
            SELECT "users"."id", "users"."name"
            FROM "users"
          SQL
        )
      end
    end

    context "with WHERE" do
      let(:query) do
        compose { |users|
          SELECT users.id, users.name
          FROM users.table
          WHERE users.name == "Jane"
        }
      end

      specify do
        expect(result).to eql(
          <<~SQL.strip
            SELECT "users"."id", "users"."name"
            FROM "users"
            WHERE "users"."name" == 'Jane'
          SQL
        )
      end
    end

    context "with WHERE and two conditions" do
      let(:query) do
        compose { |users|
          SELECT users.id, users.name
          FROM users.table
          WHERE (users.name == "Jane").OR(users.name == "Jade")
        }
      end

      specify do
        expect(result).to eql(
          <<~SQL.strip
            SELECT "users"."id", "users"."name"
            FROM "users"
            WHERE ("users"."name" == 'Jane') OR ("users"."name" == 'Jade')
          SQL
        )
      end
    end

    context "with a dynamic WHERE" do
      let(:query) do
        compose { |users|
          SELECT users.id, users.name
          FROM users.table
          WHERE users.name == "%name%"
        }
      end

      let(:result) do
        query.set(name: "Jane").to_s
      end

      specify do
        expect(result).to eql(
          <<~SQL.strip
            SELECT "users"."id", "users"."name"
            FROM "users"
            WHERE "users"."name" == 'Jane'
          SQL
        )
      end
    end

    context "without ORDER" do
      let(:query) do
        compose { |users|
          SELECT users.id, users.name
          FROM users.table
          WHERE users.name == "Jane"
        }
      end

      specify do
        expect(result).to eql(
          <<~SQL.strip
            SELECT "users"."id", "users"."name"
            FROM "users"
            WHERE "users"."name" == 'Jane'
          SQL
        )
      end
    end

    context "with ORDER" do
      let(:query) do
        compose { |users|
          SELECT users.id, users.name
          FROM users.table
          WHERE users.name == "Jane"
          ORDER users.id.desc
        }
      end

      specify do
        expect(result).to eql(
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
