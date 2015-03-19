require 'spec_helper'

describe SQL do
  it 'works' do
    ast = s(:select, s(:fields, s(:id, 'id'), s(:id, 'name')), s(:id, 'users'))
    sql = SQL[ast]

    expect(sql).to eql('SELECT "id", "name" FROM "users"')
  end
end
