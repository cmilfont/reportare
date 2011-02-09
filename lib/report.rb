class Report

  def initialize(report, data, options = {})
    @model   = load_or_compile_report(report)
    @options = options

    if @options[:data_format] == 'xml'
      process_xml(data)
      @options.delete("dados")
    end

    @fill = fill_report(options[:data_format])
  end

  def to_pdf_file(file)
    font = Java::net.sf.jasperreports.engine.design.JRDesignReportFont.new
    font.set_name "CourierNewPSMT"
    @fill.set_default_font(font)
    @fill.remove_font("Helvetica")
    pdf = JasperExportManager.export_report_to_pdf_file( @fill , file)
  end


  def to_txt
    string = java.io.ByteArrayOutputStream.new
    exporter = Java::net.sf.jasperreports.engine.export.JRTextExporter.new
    exporter.set_parameter(Java::net.sf.jasperreports.engine.export.JRTextExporterParameter::PAGE_WIDTH, java.lang.Integer.new(80) )
    exporter.set_parameter(Java::net.sf.jasperreports.engine.export.JRTextExporterParameter::PAGE_HEIGHT, java.lang.Integer.new(40) )
    exporter.set_parameter(JRExporterParameter::JASPER_PRINT, @fill)
    exporter.set_parameter(JRExporterParameter::OUTPUT_STREAM, string)
    #exporter.set_parameter(JRExporterParameter::OUTPUT_FILE_NAME, dir + '/teste')
    exporter.export_report
    return String.from_java_bytes(string.to_byte_array)
  end

  require 'irb'

  private

  def export_format(classe)
    string = java.io.ByteArrayOutputStream.new

    exporter = classe.is_a?(Class) ? classe.new : classe
    exporter.set_parameter(Java::net.sf.jasperreports.engine.export.JRTextExporterParameter::PAGE_WIDTH, java.lang.Integer.new(15))
    exporter.set_parameter(Java::net.sf.jasperreports.engine.export.JRTextExporterParameter::PAGE_HEIGHT, java.lang.Integer.new(30))
    exporter.set_parameter(JRExporterParameter::JASPER_PRINT, @fill)
    exporter.set_parameter(JRExporterParameter::OUTPUT_STREAM, string)

    exporter.export_report
    return String.from_java_bytes(string.to_byte_array)
  end

  def load_or_compile_report(report)
    if report !=~ /\.(jasper|jrxml)$/
      report = File.exists?("#{report}.jasper") ? "#{report}.jasper" : "#{report}.jrxml"
    end

    case report
    when /\.jasper$/
      Java::NetSfJasperreportsEngineUtil::JRLoader.load_object(report)
    when /\.jrxml$/
      Java::NetSfJasperreportsEngine::JasperCompileManager.compile_report(report)
    else
      raise "There is no way to convert the file you sent to a JasperReport - #{report}"
    end
  end

  def process_xml(xml_data)

    #document = JRXmlUtils.parse( org.xml.sax.InputSource.new(
     #                            java.io.StringReader.new(xml_data)) )

    document = JRXmlUtils.parse( org.xml.sax.InputSource.new(
                                  java.io.FileInputStream.new(xml_data) ) )

    @xml_document = Java::NetSfJasperreportsEngineData::JRXmlDataSource.new(document, @options[:xpath_root])
    true
  end

  def fill_report(data_format)
    if data_format == 'xml'
      JasperFillManager.fill_report(@model, @options, @xml_document)
    else
      JasperFillManager.fill_report(@model, @options,
             ActiveRecord::Base.connection.instance_variable_get(:@connection).
                                           instance_variable_get(:@connection))
    end
  end
end

