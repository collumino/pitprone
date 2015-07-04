module PdfHelper

  def font_files
    font_path = File.expand_path('../pdf_fonts',  __FILE__)
    {
          :normal => File.join(font_path, "PTC55F.ttf"),
          :thin => File.join(font_path,"PTS55F.ttf"),
          :italic => File.join(font_path,"PTS56F.ttf"),
          :bold => File.join(font_path,"PTC75F.ttf"),
    }
  end

  def sender
    "collumino GmbH,  Industriestrasse 78,  4609 Olten"
  end

  def receiver(address)
    return '' if address.nil?
    [
      receiver_name(address),
      address.street,
      address.city,
    ].compact.flatten
  end

  def receiver_name(address)
    "#{address.firstname} #{address.name}"
  end

  def pos_invoice(positions)
    pos_lines = positions.each_with_index.collect{|pos, index|
      [sprintf('%0.3d', index + 1), pos.quantity, pos.ingredient.name, '2.5', float_conversion(pos.total.to_f) ]
    }
    pos_lines.unshift(['Pos','Menge','Bezeichnung / Text', 'MwSt. [%]', 'Brutto [CHF]'])
  end

  def build_address(address)
    [
      [render_gender(address.gender), address.firstname, address.lastname].compact.join(' '),
      [address.address1, address.address2].compact.join(' '),
      [address.zipcode, address.city].compact.join(' ')
    ].join("\n")
  end

  def float_conversion(float)
    return '' if float.nil?
    sprintf("%0.2f",float)
  end

  def email_to_use
    @order.user ? @order.user.email : @order.email
  end

  def logo
    path = File.join(File.expand_path('../pdf_images',  __FILE__), 'pitprone_logo_black.svg')
    logo = File.open( path )
    svg logo, :at => [bounds.right - 180, bounds.top], :width => 180
  end

end
