=begin
require 'socket'
include Socket::Constants
socket = Socket.new(:UNIX, :RAW, 0)
sockaddr = Socket.pack_sockaddr_in(8081, 'localhost')
socket.connect(sockaddr)
json = {:report => "reports/razao2", :datasource => "exemplo/razao2.xml",:xpath_root => "razao"}.to_json
socket.puts json
puts socket.readline.chomp
socket.close
=end
require 'rubygems'
require 'socket'
require 'json'
json = {:report => "reports/razao2",
  :datasource => "exemplo/razao_1_1_20090101_20090331_1295982551.xml",
  :xpath_root => "/razao/item",
  :file => "exemplo/razao.pdf"
}.to_json

sock = TCPSocket.new("localhost", 8081)
b = sock.write json

puts sock.recv(b)

sock.close
puts "terminou"

