require_relative '../ben'


game = Ben::Game.new 20
puts "Before file persistence, game.word = #{game.word}"
puts
game.save
puts "Game data in saved file:\n#{ File.open( 'game_data', 'r' ) do |f| f.readlines.join end }"
puts
game.word = "modified_word"
puts "game.word modified before loading saved state: #{ game.word }"
puts
game = Ben::Game.load
puts "game object after loading saved state: #{game}\n"
puts "game.word after loading saved state: #{ game.word }"
