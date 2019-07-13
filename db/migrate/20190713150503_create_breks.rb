class CreateBreks < ActiveRecord::Migration[5.2]
  def change
    create_table :breks do |t|
      t.text :message
      t.timestamps
    end
  end
end
