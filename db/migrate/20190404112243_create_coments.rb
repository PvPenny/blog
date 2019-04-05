class CreateComents < ActiveRecord::Migration[5.2]
  def change
    create_table :coments do |t|
      t.text :text
      t.belongs_to :user, index: true
      t.belongs_to :post, index: true
      t.timestamps
    end
  end
end
