class AddPublishDateToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :publish_date, :datetime, default: DateTime.now
  end
end
