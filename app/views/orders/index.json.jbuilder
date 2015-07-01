json.array!(@orders) do |order|
  json.extract! order, :id, :user_id, :total, :state
  json.url order_url(order, format: :json)
end
