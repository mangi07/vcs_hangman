require 'yaml'

# TODO refactor file names "game_data" and "enable.txt" to variables

module Ben
	class Game
		attr_accessor :guesses, :word, :difficulty, :blanks, :used_letters, :status
		
		def initialize( letters_in_word )
			@difficulty = letters_in_word
			@guesses = 5

			# Get word from enable.txt based on difficulty with max length of 28 not including newline character
			# (Used grep on command line to find longest word.)
			@word = _get_random_word( "enable.txt", @difficulty )
			@blanks = ""
			@word.length.times { @blanks << "_" }
			@used_letters = ""
			@status = 0 # -1 loss, 0 keep playing, 1 win
		end

		# returns a Hash containing file object of filtered words and its word count
		def _filter_words_of_length( letters, from_file )
			word_count = 0
			temp_words = File.open( "temp_words.txt", "w+" )
			dictionary = File.open( from_file, "r" )
			while !dictionary.eof?
				line = dictionary.readline
				# adding one accounts for newline character
				if line.length == letters + 1
					temp_words.puts line.strip!
					word_count += 1
				end
			end
			temp_words.close
			return { :file_name => "temp_words.txt", :word_count => word_count }
		end

		# returns a word with the specified number of letters
		def _get_random_word( file_name, letters )
			word
			words_data = _filter_words_of_length( letters, file_name )
			# Generate random number in range up to number of words in temp_words file
			line_number = rand( words_data[:word_count] )
			temp_words = File.open( words_data[:file_name] )
			# Get the word at the line number of random number and return it
			temp_words.each_with_index do |line, idx|
				if idx == line_number
					word = line.strip!
					temp_words.close
					return word
				end
			end
			return word # If we got here, this should return nil
		end

		def make_guess( letter )
			wrong_guess = true
			@used_letters << letter
			@word.split("").each_with_index do |c, idx|
				if letter == c
					@blanks[ idx ] = letter
					wrong_guess = false
				end
			end
			if wrong_guess
				@guesses -= 1
			end
		end

		def check_win_loss
			if @guesses < 1 && @blanks != @word
				@status = -1
				return "loss"
			elsif @blanks == @word
				@status = 1
				return "win"
			else
				@status = 0
				return nil
			end
		end

		def save
			File.open( "game_data", "w" ) { |f| f.puts YAML::dump( self ) }
		end

		def self.load
			game_data = File.open( "game_data", "r" ) { |f| f.readlines.join }
			YAML::load( game_data )
		end

		# Add to tests/ben_test.rb
		def self.exist?
			File.exist?( "game_data" )
		end

		def delete_file
			# File.unlink
			if File.exist?( "game_data" )
				File.unlink( "game_data" )
			end
		end

	end
		
end

