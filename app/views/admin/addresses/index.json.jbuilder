json.array!(@addresses) do |address|
  json.extract! address, :id, :user_id, :name, :firstname, :street, :city, :phone, :mobile
  json.url address_url(address, format: :json)
end
