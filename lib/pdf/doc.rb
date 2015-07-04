require File.join(File.expand_path('../', __FILE__), 'pdf_helper')
require 'prawn'
require "prawn/font/ttf"
require 'prawn-svg'
require 'prawn/table'


module Pdf
  class Doc < Prawn::Document
    include PdfHelper

    attr_accessor :invoice_settings

    def initialize(options)
      super (options.pdf_settings)
      @order = options.obj

      font_families.update("PtSans" => font_files)
      font('PtSans')
      font_size 10

    end

    def build_head
      top = bounds.top - 50.mm

      bounding_box([0, top], :width => 90.mm) {
        indent(10) { text sender, :size => 7, :style => :thin }
        stroke { horizontal_rule }
        move_down 12.mm
        indent(10) {
          receiver(@order.user.address).each { |line| text line }
        }
      }
      invoice_context(top)
    end

    def invoice_context(top)

      bounding_box([bounds.right - 180, top], :width => 180, :height => 55.mm) {
        text "Auftrags Nr. #{@order.id}", :style => :bold, :size => 13
        move_down 5.mm

        data = []
        data << ['Datum:', I18n.l(@order.created_at.to_date)]
        bounding_box([bounds.right - 180, cursor], :width => 180, :height => 15.mm) {
          table(data, :position => :right, :width => 180, :cell_style => {:border_width => 0, :padding => [0, 3, 1, 0]}) {
            column(0).style({:width => 90})
            column(1).style({:align => :right})
          }
        }
        service_contact
      }
    end

    def build_position_block
      pizza = @order.pizzas.last
      text "Pizza #{I18n.t(pizza.size)}", :style => :bold, :size => 13
      data = pos_invoice(@order.pizzas.last.pizza_items)
      # 'Pos','Menge','Bezeichnung / Text', 'MwSt. [%]', 'Brutto [CHF]'
      table(data, :header => true, :cell_style => {:borders => []}, :width => bounds.right) {
        column(0).style({:size => 7, :align => :center, :text_color => '888888', :width => 30})
        style(row(0), :size => 7, :background_color => 'eeeeee', :valign => :center, :text_color => '888888')
        column(1).style(:width => 35)
        column(2)
        column(3).style({:align => :right, :width => 35})
        column(4).style({:align => :right, :width => 55})
      }

      data = [['Gesamt',float_conversion(@order.total)]]

      bounding_box([bounds.right - 250, cursor], :width => 250) {
        table(data, :position => :right, :cell_style => {:borders => []}) {
          column(1).style(:align => :right, :font_style => :bold, :width => 100)
        }
      }
    end

    def line_position(item)
      @order.line_items.index(item) + 1
    end

    def finish_position_block
      move_down 20.mm

      text "Vielen Dank für Ihre Bestellung."
      move_down 10
      text "Freundliche Grüsse"
      move_down 5
      text "pitprone"
    end

    def build_page_footer(stamp = nil, drop_last_page = false)
      return if stamp.blank?

      repeat(:all, :dynamic => true) do
        next if drop_last_page && (page_number == page_count)
        bounding_box([0, -50], :width => bounds.right, :height => 24) { page_footer }
        stamp_at stamp.downcase, [(bounds.right / 2) - 150, (bounds.top / 2) - 100] if stamp
        fill_color '444444'
        draw_text "Auftrags-ID: #{@order.id}", {:at => [0, -41], :size => 8}
        draw_text "Seite #{page_number} von #{page_count}", {:at => [bounds.right - 70, -41], :size => 8, :width => 70}
      end
    end

    private

    def float_conversion(float)
      return '' if float.nil?
      sprintf("%0.2f", float)
    end

    def page_footer
        text "pitprone ist ein Pitch der <b>collumino GmbH</b>", :inline_format => true, :size => 7, :color => 'aaaaaa', :align => :center
    end

    def service_contact
      text "Dienstleister", :font_style => :thin, :size => 8, :color => '888888'
      hline
      move_down 5
      indent(3) do
        text "E-Mail:   andreas.buerk@collumino.com", :size => 8
        text "Telefon: 0815 123 123 12", :size => 8
        text "Montag - Freitag: 8.00 bis 18.00 Uhr ", :size => 8
      end
      move_down 5
      hline
    end

    def hline
      stroke_color "888888"
      stroke {
        self.line_width = 0.25
        horizontal_rule
      }
    end
  end
end
