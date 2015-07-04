require 'pdf_generator'
namespace :pdf do

  desc "generates order document"
  task :generate, [:call_from] =>:environment do |task, args|
    result = PdfGenerator.create_doc(Order.last)
  end


end
