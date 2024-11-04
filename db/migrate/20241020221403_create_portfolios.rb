class CreatePortfolios < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolios do |t|
      t.string :preferred_email
      t.boolean :active
      t.text :summary
      t.text :skills
      t.belongs_to :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
