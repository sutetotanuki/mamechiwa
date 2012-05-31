class NoDefaults < ActiveRecord::Migration
  def self.up
    create_table :no_defaults do |t|
      t.string :group_type
      t.text :options
    end
  end

  def self.down
    drop_table :no_defaults
  end
end
