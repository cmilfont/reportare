require 'rubygems'
require "bundler/setup"

require 'eventmachine'
require 'json'
require("init.rb")

module ReportServer
  def post_init
    puts "-- someone connected to the echo server!"
  end

  def receive_data data
    begin
      puts "Dados recebidos: "
      puts data
      config = JSON.parse(data)
      puts "Config gerado: "
      puts config.to_json
      relatorio = Report.new config["report"], config["datasource"],
                     {
                      :data_format => "xml",
                      :xpath_root => config["xpath_root"]
                     }

      relatorio.to_pdf_file(config["file"])
      puts "Arquivo criado"
      puts config["file"]
      send_data config["file"]
      #close_connection
    rescue JSON::ParserError => e
      puts e
      puts "Erro! JSON inválido"
    end
  end

end

EventMachine::run {
  EventMachine::start_server "127.0.0.1", 8081, ReportServer
  puts 'running echo server on 8081'
}

