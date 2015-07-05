class AddPdfToPizza < ActiveRecord::Migration
  def change
    add_column :orders, :pdf_is_avaliable, :string
  end
end
