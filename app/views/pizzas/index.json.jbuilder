json.array!(@pizzas) do |pizza|
  json.extract! pizza, :id, :order_id, :total
  json.url pizza_url(pizza, format: :json)
end
