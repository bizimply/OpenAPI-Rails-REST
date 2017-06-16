ActiveRecord::Schema.define do
  self.verbose = false

  create_table :products, :force => true do |t|
    t.string :product_id
    t.string :description
    t.string :name
    t.string :capacity
    t.string :image

    t.timestamps(null: true)
  end
end