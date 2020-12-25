# frozen_string_literal: true

RSpec.describe SQL, ".compose" do
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
          <<~SQL.strip.gsub("\n", " ")
            SELECT "users"."id", "users"."name"
            FROM "users"
          SQL
        )
      end
    end

    context "with literals in WHERE" do
      let(:query) do
        compose {
          SELECT `"users"."id"`, `"users"."name"`
          FROM `"users"`
          WHERE `"users"."name"` == "Jane"
        }
      end

      specify do
        expect(result).to eql(
          <<~SQL.strip.gsub("\n", " ")
            SELECT "users"."id", "users"."name"
            FROM "users"
            WHERE "users"."name" = 'Jane'
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
          <<~SQL.strip.gsub("\n", " ")
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
          <<~SQL.strip.gsub("\n", " ")
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
          <<~SQL.strip.gsub("\n", " ")
            SELECT "users"."id", "users"."name"
            FROM "users"
            WHERE "users"."name" = 'Jane'
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
          <<~SQL.strip.gsub("\n", " ")
            SELECT "users"."id", "users"."name"
            FROM "users"
            WHERE ("users"."name" = 'Jane') OR ("users"."name" = 'Jade')
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
          <<~SQL.strip.gsub("\n", " ")
            SELECT "users"."id", "users"."name"
            FROM "users"
            WHERE "users"."name" = 'Jane'
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
          <<~SQL.strip.gsub("\n", " ")
            SELECT "users"."id", "users"."name"
            FROM "users"
            WHERE "users"."name" = 'Jane'
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
          <<~SQL.strip.gsub("\n", " ")
            SELECT "users"."id", "users"."name"
            FROM "users"
            WHERE "users"."name" = 'Jane'
            ORDER BY "users"."id" DESC
          SQL
        )
      end
    end
  end

  describe "extending existing SQL" do
    context "SELECT" do
      let(:source_query) do
        compose { SELECT(`id`, `name`).FROM(`users`) }
      end

      context "with args" do
        let(:query) do
          source_query.append_to(:select, new_identifier).to_s
        end

        describe "appending to SELECT using a symbol" do
          let(:new_identifier) { :title }

          it "returns a new SQL statement" do
            expect(result).to eql(
              <<~SQL.strip.gsub("\n", " ")
                SELECT id, name, title
                FROM users
              SQL
            )
          end
        end

        describe "appending to SELECT using a string" do
          let(:new_identifier) { "title" }

          it "returns a new SQL statement" do
            expect(result).to eql(
              <<~SQL.strip.gsub("\n", " ")
                SELECT id, name, title
                FROM users
              SQL
            )
          end
        end
      end

      context "with a block" do
        describe "appending to SELECT using a sub-select" do
          let(:query) do
            source_query.append_to(:select) { SELECT(`title`).FROM(`posts`) }.to_s
          end

          it "returns a new SQL statement" do
            expect(result).to eql(
              <<~SQL.strip.gsub("\n", " ")
                SELECT id, name, (SELECT title FROM posts)
                FROM users
              SQL
            )
          end
        end
      end
    end

    context "WHERE" do
      let(:source_query) do
        compose { SELECT(`id`, `name`).FROM(`users`).WHERE(`id` == 1) }
      end

      context "with a hash" do
        let(:query) do
          source_query.append_to(:where, name: 'Jane').to_s
        end

        describe "append_to" do
          it "returns a new SQL statement" do
            expect(result).to eql(
              <<~SQL.strip.gsub("\n", " ")
                SELECT id, name
                FROM users
                WHERE id = 1 AND name = 'Jane'
              SQL
            )
          end
        end
      end

      context "with a block" do
        let(:query) do
          source_query.append_to(:where) { WHERE(`name` == 'Jane') }.to_s
        end

        describe "append_to" do
          it "returns a new SQL statement" do
            expect(result).to eql(
              <<~SQL.strip.gsub("\n", " ")
                SELECT id, name
                FROM users
                WHERE id = 1 AND name = 'Jane'
              SQL
            )
          end
        end
      end
    end

    context "ORDER" do
      let(:source_query) do
        compose { SELECT(`id`, `name`).FROM(`users`).ORDER(`id`.desc) }
      end

      context "with a hash" do
        let(:query) do
          source_query.append_to(:order, name: :asc).to_s
        end

        describe "append_to" do
          it "returns a new SQL statement" do
            expect(result).to eql(
              <<~SQL.strip.gsub("\n", " ")
                SELECT id, name
                FROM users
                ORDER BY id DESC, name ASC
              SQL
            )
          end
        end
      end

      context "with a block" do
        let(:query) do
          source_query.append_to(:order) { ORDER(`name`.asc) }.to_s
        end

        describe "append_to" do
          it "returns a new SQL statement" do
            expect(result).to eql(
              <<~SQL.strip.gsub("\n", " ")
                SELECT id, name
                FROM users
                ORDER BY id DESC, name ASC
              SQL
            )
          end
        end
      end
    end
  end

  describe "appending new nodes" do
    let(:source_query) do
      compose { SELECT(`id`, `name`).FROM(`users`) }
    end

    let(:result) do
      query.to_s
    end

    describe "SELECT" do
      context "with args" do
        let(:query) do
          source_query.append(:where, name: 'Jane')
        end

        specify do
          expect(result).to eql(
            <<~SQL.strip.gsub("\n", " ")
              SELECT id, name
              FROM users
              WHERE name = 'Jane'
            SQL
          )
        end
      end

      context "with args when :order is set already" do
        let(:source_query) do
          compose { SELECT(`id`, `name`).FROM(`users`).ORDER(`name`.asc) }
        end

        let(:query) do
          source_query.append(:where, name: 'Jane')
        end

        specify do
          expect(result).to eql(
            <<~SQL.strip.gsub("\n", " ")
              SELECT id, name
              FROM users
              WHERE name = 'Jane'
              ORDER BY name ASC
            SQL
          )
        end
      end

      context "with a block" do
        let(:query) do
          source_query.append(:where) { WHERE(`name` == 'Jane') }
        end

        specify do
          expect(result).to eql(
            <<~SQL.strip.gsub("\n", " ")
              SELECT id, name
              FROM users
              WHERE name = 'Jane'
            SQL
          )
        end
      end
    end

    describe "ORDER" do
      context "with args" do
        let(:query) do
          source_query.append(:order, name: :asc)
        end

        specify do
          expect(result).to eql(
            <<~SQL.strip.gsub("\n", " ")
              SELECT id, name
              FROM users
              ORDER BY name ASC
            SQL
          )
        end
      end

      context "with a block" do
        let(:query) do
          source_query.append(:order) { ORDER(`name`.asc) }
        end

        specify do
          expect(result).to eql(
            <<~SQL.strip.gsub("\n", " ")
              SELECT id, name
              FROM users
              ORDER BY name ASC
            SQL
          )
        end
      end
    end
  end

  describe "aliasing nodes" do
    let(:result) { query.to_s }

    describe "SELECT" do
      let(:query) do
        compose { SELECT(`id`, `user_name`.AS(`name`)).FROM(`users`) }
      end

      specify do
        expect(result).to eql(
          <<~SQL.strip.gsub("\n", " ")
            SELECT id, user_name AS name
            FROM users
          SQL
        )
      end
    end
  end
end
