require 'rubygems'
require 'eventmachine'
require 'json'

class Echo < EventMachine::Connection
  def initialize(*args)
    super
    send_data({
      :report     => "reports/razao",
      :datasource => "exemplo/razao.xml",
      :xpath_root => "razao"
    }.to_json)
  end

  def receive_data(data)
    p data
    #send_data data
    close_connection_after_writing
    exit
  end

  def unbind
    p ' connection totally closed'
  end
end

EventMachine.run {
  EventMachine.connect '127.0.0.1', 8081, Echo
}

