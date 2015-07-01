json.array!(@pizza_items) do |pizza_item|
  json.extract! pizza_item, :id, :pizza_id, :ingredient_id, :quantity, :total
  json.url pizza_item_url(pizza_item, format: :json)
end
