require 'sinatra'
require 'sinatra/reloader' if development?
also_reload 'ben.rb'

require_relative 'ben'

# starting with fresh settings
set :styles, {:background => "#000", :color => "#fff"}
set :game_data, nil

get '/' do
	erb :index, :locals => {
		:styles => settings.styles,
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


# load game from YAML
def load_game
	settings.game_data = Ben::Game.load
	"Game loaded: difficulty = #{ settings.game_data }"
end

# find word based on difficulty in GET request
def new_game
	response
	if params["difficulty"]
		difficulty = params["difficulty"]
		settings.game_data = Ben::Game.new( Integer difficulty )
		response = "new game loaded on server"
	else
		response = "server couldn't load new game"
	end
	return response
end

# save game to YAML
def save_game
	response
	if settings.game_data
		settings.game_data.save
		response = "Game saved on server as YAML file."
	else
		response = "No game loaded yet, so no game saved."
	end
	return response
end

# get '/guess' do
# 	difficulty
# 	guesses

# 	if params["guess"] && params["guess"] != ""
# 		guess = params["guess"]
# 		params["guess"] = ""
# 	end
# 	if params["cheat"] && params["cheat"] == "true"
# 		message << "<p>#{settings.number}</p>"
# 	end
# 	message << "<p>You have #{Ben::Counter.get} guesses remaining</p>"
# 	erb :index, :locals => {
# 		:styles => settings.styles,
# 		:message => message
# 	}
# 	#throw params.inspect
# end

# TODO
#
# when loading YAML into Ben::Game object
#   get the game data (all except the word) in the client dom
#   (send as JSON? --difficulty, guesses, word string reflecting guesses so far, and used letters)
#   (you'll need to add functionality for the last two on both the server and the client)
#
# add one more route to check game state and
#   corresponding ajax call to check guess 
#   (and of course, before this, functionality to make the guess)
# 
# pretty up with CSS (probably bootstrap)


