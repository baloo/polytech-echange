class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :announcement_id
      t.string :title
      t.references :announcement
      t.references :user
      t.text :body
      t.string :materialized_path

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
