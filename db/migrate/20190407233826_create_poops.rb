class CreatePoops < ActiveRecord::Migration[5.2]
  def change
    create_table :poops do |t|
      t.string :user_id, null: false
      t.string :session_id, null: false
      t.string :aws_timestamp, null: false
      t.string :locale, null: false
      t.timestamps
    end
  end
end
