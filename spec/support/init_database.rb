require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:',
  verbosity: 'quiet'
)

ActiveRecord::Base.connection.create_table :users do |table|
  table.string :username
  table.integer :reputation
  table.decimal :coins, default: 0
  table.decimal :tax, default: 30
  table.references :level
  table.timestamps
end

ActiveRecord::Base.connection.create_table :levels do |table|
  table.string :title
  table.integer :experience
  table.timestamps
end

ActiveRecord::Base.connection.create_table :privileges do |table|
  table.string :name
  table.string :technical_name
  table.decimal :value
  table.timestamps
end

ActiveRecord::Base.connection.create_table :level_privileges do |table|
  table.references :level, foreign_key: true, index: true
  table.references :privilege, foreign_key: true, index: true
end
