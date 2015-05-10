require 'spec_helper'

describe SQL do
  it 'works' do
    ast = s(:select,
      s(:fields, s(:id, 'id'), s(:id, 'name')),
      s(:id, 'users'),
      s(:where,
        s(:or,
          s(:and,
            s(:eq, s(:id, 'name'), s(:string, 'Jane')),
            s(:eq, s(:id, 'id'), s(:integer, 1))
          ),
          s(:and,
            s(:eq, s(:id, 'name'), s(:string, 'John')),
            s(:eq, s(:id, 'id'), s(:integer, 2))
          )
        )
      )
    )
    sql = SQL[ast]

    expect(sql).to eql <<-SQL.gsub(/\s+/, ' ').strip
      SELECT "id", "name"
      FROM "users"
      WHERE (("name" = 'Jane' AND "id" = 1) OR ("name" = 'John' AND "id" = 2))
    SQL
  end
end
