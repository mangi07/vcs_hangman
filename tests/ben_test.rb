require_relative '../ben'
require 'json'

# run ruby ben_test.rb in shell

puts "*** Ben::Game test ***"
puts
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
puts "*** End Ben::Game test ***"
puts
puts
puts


puts "*** Ben::Game object to JSON string test ***"
puts
puts "Creating new game for JSON test..."
game = Ben::Game.new 17
puts
# Borrowed from: http://stackoverflow.com/questions/5030553/ruby-convert-object-to-hash
game_hash = {}
game_hash = game.instance_variables.each_with_object( {} ) do |var, game_hash|
	#unless var.to_s == "@word"
		game_hash[ var.to_s.delete( "@" ) ] = game.instance_variable_get( var )
	#end
end
puts "First, we need a game_hash: #{ game_hash }"
puts
puts "Then, we convert to JSON string..."
puts
game_json = JSON.generate( game_hash )
puts "JSON string: #{ game_json }"
puts
puts "*** End Ben::Game object to JSON string test ***"
puts
puts
puts


puts "*** Ben::Game make guess test ***"
puts
puts "Creating new game..."
game = Ben::Game.new 4
puts "Secret word: #{game.word}"
while true
	puts "Guess a letter:"
	letter = gets
	game.make_guess letter.strip!
	puts
	puts "You guessed #{letter}"
	puts "Letters used so far: #{game.used_letters}"
	puts
	puts game.blanks
	if game.check_win_loss == "win"
		puts "YOU WIN"
		break
	elsif game.check_win_loss == "loss"
		puts "YOU LOSE"
		break
	end
end

