class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :identifier

      t.timestamps
    end
  end
end
