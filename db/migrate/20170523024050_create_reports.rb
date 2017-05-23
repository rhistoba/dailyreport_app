class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.date :date
      t.string :title
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :reports, [:user_id, :created_at]
  end
end
