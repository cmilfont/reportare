require 'rubygems'
require 'eventmachine'
require 'json'

class ClientReport < EventMachine::Connection
  def initialize(*args)
    super
    json = {:report => "reports/razao2",
      :datasource => "exemplo/razao2.xml",
      :xpath_root => "/razao/item",
      :file => "/home/cmilfont/projetos/n1r/tmp/razao.pdf"
    }.to_json
    send_data(json)
  end

  def receive_data(data)
    p data
    #send_data data
    close_connection
  end

  def unbind
    p ' connection totally closed'
    detach
  end
end

EventMachine.run {
  EventMachine.connect '127.0.0.1', 8081, ClientReport
}

