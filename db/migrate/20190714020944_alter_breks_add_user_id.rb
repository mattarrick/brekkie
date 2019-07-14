class AlterBreksAddUserId < ActiveRecord::Migration[5.2]
  def change
    add_column :breks, :user_id, :integer
    add_index :breks, :user_id
  end
end
