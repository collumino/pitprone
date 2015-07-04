# encoding: UTF-8

require "prawn/measurement_extensions"
require 'pdf/doc'
require 'fileutils'

class PdfGenerator
  BASE_PATH = File.join(Rails.root, 'public', 'pitprone', 'pdf_test') if Rails.env.include?('test')
  BASE_PATH = File.join(Rails.root, 'public', 'pitprone', 'pdf') if Rails.env.include?('development')
  BASE_PATH ||= '/var/www/webroot/shared/public/pdf'

  class << self
    def meta(options)
      {
        :Title => options[:doc_header],
        :Creator => "pitprone.ch",
        :Producer => '',
        :CreationDate => Time.now
      }
    end

    def init_params(options)
      {
        :page_size => 'A4',
        :page_layout => :portrait,
        :bottom_margin => 30.mm,
        :top_margin => 6.mm,
        :left_margin => 15.mm,
        :right_margin => 15.mm,
        :info => self.meta(options)
      }
    end

    def create_doc(order_obj)
      pdf = PdfGenerator.new(order_obj)
      pdf.doc_builder
      pdf.save_file
      # [pdf.file_stream, pdf.message_tracker]
      puts pdf.file_target
    end

  end

  attr_accessor :obj, :pdf_settings, :file_target

  def initialize(order_obj)
    self.obj = order_obj
    self.pdf_settings = PdfGenerator.init_params(doc_header: "Auftrag Nr. #{self.obj.id}")
    self.file_target = File.join(target_dir, "Auftrag_#{self.obj.id}.pdf")
  end

  def doc_builder
    @doc = Pdf::Doc.new(self)
    @doc.logo
    @doc.build_head
    @doc.build_position_block
    @doc.finish_position_block
    @doc.build_page_footer
  end

  def save_file
    FileUtils.rm_f(self.file_target)
    @doc.render_file self.file_target
    File.size?(self.file_target)
  end

  # def file_stream
  #   File.read(self.file_target)
  # end

  def target_dir
    working_dir = File.join(BASE_PATH, self.obj.id.to_s)
    FileUtils.mkdir_p(working_dir) unless Dir.exists?(working_dir)
    working_dir
  end

  def locate_order
    obj.respond_to?(:order) ? obj.order : obj
  end
end
