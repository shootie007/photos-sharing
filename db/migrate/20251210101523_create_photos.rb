class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, limit: 30, null: false

      t.timestamps
    end

    add_index :photos, [:user_id, :created_at]
  end
end

