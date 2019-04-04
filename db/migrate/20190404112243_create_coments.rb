class CreateComents < ActiveRecord::Migration[5.2]
  def change
    create_table :coments do |t|
      t.text :text
      t.references :user, index: true
      t.references :post, index: true
      t.timestamps
    end
  end
end
