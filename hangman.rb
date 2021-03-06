require 'sinatra'
require 'sinatra/reloader' if development?
#also_reload 'ben.rb'
require_relative 'ben'
require 'json'

# starting with fresh settings
set :styles, {:background => "#000", :color => "#fff"}
set :game_data, nil

get '/' do
	erb :index, :locals => {
		:game_data => settings.game_data
	}
end

# These routes return responses for client logging.
get '/game/load' do
	load_game
end
get '/game/new' do
	new_game
end
get '/game/save' do
	save_game
end
get '/game/guess' do
	make_guess
end
get '/game/clear' do
	clear_saved_game
end
get '/game/checkSaved' do
	game_saved?
end
get '/game/reveal' do
	settings.game_data.word
end


# load game from YAML
def load_game
	settings.game_data = Ben::Game.load
	game_json
end

# find word based on difficulty in GET request
def new_game
	response
	if params["difficulty"]
		difficulty = params["difficulty"]
		settings.game_data = Ben::Game.new( Integer difficulty )
		response = game_json
	else
		response = "Server couldn't load new game."
	end
	return response
end

# save game to YAML
def save_game
	response
	if settings.game_data
		settings.game_data.save
		response = "Game saved."
	else
		response = "No game loaded yet, so no game saved."
	end
	return response
end

def make_guess
	if params["letter"]
		letter = params["letter"]
		settings.game_data.make_guess letter
		settings.game_data.check_win_loss
	end
	return game_json
end

def game_json
	game_hash = {}
	game = settings.game_data
	game_hash = game.instance_variables.each_with_object( {} ) do |var, game_hash|
		# We don't want to send the word being guessed: 
		unless var.to_s == "@word"
			game_hash[ var.to_s.delete( "@" ) ] = game.instance_variable_get( var )
		end 
	end
	game_json = JSON.generate( game_hash )
	"#{ game_json }"
end

def clear_saved_game
	settings.game_data.delete_file
	settings.game_data = nil
	"Game data on server deleted."
end

def game_saved?
	if Ben::Game.exist?
		return "true"
	else
		return "false"
	end
end

# TODO
# 
# pretty up with CSS (probably bootstrap)


