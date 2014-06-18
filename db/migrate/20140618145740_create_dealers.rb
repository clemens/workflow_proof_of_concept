class CreateDealers < ActiveRecord::Migration
  def change
    create_table :dealers do |t|

      t.timestamps
    end
  end
end
