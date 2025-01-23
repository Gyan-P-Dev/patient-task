class AddIndexToPatientsEmail < ActiveRecord::Migration[7.1]
  def change
    add_index :patients, :email, unique: true
  end
end
