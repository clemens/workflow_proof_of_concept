class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :brand, index: true
      t.references :dealer, index: true
      t.integer :car_model_id

      t.string :workflow_id

      t.string :state

      t.string :number

      t.datetime :accepted_at
      t.datetime :completed_at

      t.text :finish_comment
      t.text :accept_comment
      t.text :complete_comment

      t.timestamps
    end
  end
end
