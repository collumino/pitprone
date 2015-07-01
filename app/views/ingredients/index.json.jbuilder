json.array!(@ingredients) do |ingredient|
  json.extract! ingredient, :id, :property_id, :name, :additional_remarks, :price, :is_default, :vegan
  json.url ingredient_url(ingredient, format: :json)
end
