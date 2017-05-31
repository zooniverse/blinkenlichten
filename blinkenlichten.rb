require 'bundler'
Bundler.require(:default)

require_relative 'lib/board'

puts "Connecting to Pusher"

socket = PusherClient::Socket.new('79e8e05ea522377ba6db', secure: true)
socket.connect(true)

socket.subscribe('panoptes')
socket.subscribe('talk')
socket.subscribe('ouroboros')

socket['panoptes'].bind("classification")  { |data| Board.instance.pins[:panoptes_classification].trigger }
socket['talk'].bind("comment")             { |data| Board.instance.pins[:talk_comment].trigger }
socket['ouroboros'].bind("classification") { |data| Board.instance.pins[:ouroboros_classification].trigger }
socket['ouroboros'].bind("comment")        { |data| Board.instance.pins[:ouroboros_comment].trigger }

puts "Connected"

loop do
  sleep 1
end
