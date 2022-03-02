class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.text :name
      t.string :password_digest

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
