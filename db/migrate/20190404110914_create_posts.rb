class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :text
      t.boolean :published, default: true

      t.timestamps
    end
  end
end
