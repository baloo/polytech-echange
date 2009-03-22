class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :announcement_id
      t.string :title
      t.string :sender
      t.text :body
      t.string :materialized_path

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
