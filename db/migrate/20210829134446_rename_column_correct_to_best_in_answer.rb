class RenameColumnCorrectToBestInAnswer < ActiveRecord::Migration[6.1]
  def change
    change_column :answers, :correct, :boolean, default: false
    rename_column :answers, :correct, :best
  end
end
