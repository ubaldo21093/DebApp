class UpdatePortfoliosOnDeleteCascade < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :portfolios, :students 
    add_foreign_key :portfolios, :students, on_delete: :cascade

  end
end
