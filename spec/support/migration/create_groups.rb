class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :group_type
      t.text :options
    end
  end

  def self.down
    drop_table :groups
  end
end
