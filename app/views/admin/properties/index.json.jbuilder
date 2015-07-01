json.array!(@properties) do |property|
  json.extract! property, :id, :sugar, :antioxidant, :dye, :conserve, :phophate
  json.url property_url(property, format: :json)
end
