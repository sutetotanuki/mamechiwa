class CreateMamechiwaTests < ActiveRecord::Migration
  def self.up
    create_table :mamechiwa_tests do |t|
      t.text :options
    end
  end

  def self.down
    drop_table :mamechiwa_tests
  end
end
