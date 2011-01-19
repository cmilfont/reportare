if RUBY_PLATFORM =~ /java/i
  require 'java'
  #require 'tempfile'

  path = File.join( File.dirname(__FILE__), 'jars' )
  Dir.entries( path ).each do |file|
    if file =~ /\.jar$/
      require File.join( path, file )
    end
  end

  java_import Java::net::sf::jasperreports::engine::util::JRXmlUtils
  java_import Java::net::sf::jasperreports::engine::query::JRXPathQueryExecuterFactory
  java_import Java::net::sf::jasperreports::engine::JasperFillManager
  java_import Java::net::sf::jasperreports::engine::JasperExportManager
  java_import Java::net::sf::jasperreports::engine::JRExporterParameter

  require 'lib/relatorio'
end

