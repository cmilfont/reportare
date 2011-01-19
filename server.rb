=begin
require("rubygems")
require("init.rb")
relatorio = Relatorio.new "reports/razao", "exemplo/razao.xml",
                  {:data_format => "xml", :xpath_root => "razao"}
relatorio.to_pdf
=end


require 'rubygems'
require 'eventmachine'
require 'json'
require("init.rb")

module EchoServer
  def post_init
    puts "-- someone connected to the echo server!"
  end

  def receive_data data
    config = JSON.parse(data)
    relatorio = Relatorio.new config["report"], config["datasource"],
                   {
                    :data_format => "xml",
                    :xpath_root => config["xpath_root"]
                   }

    send_data relatorio.to_pdf
  end
end

EventMachine::run {
  EventMachine::start_server "127.0.0.1", 8081, EchoServer
  puts 'running echo server on 8081'
}

