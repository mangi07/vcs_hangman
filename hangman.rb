require 'sinatra'
require 'sinatra/reloader' if development?
also_reload 'ben.rb'

require_relative 'ben'




get '/' do
	message = ""
	if params["guess"] && params["guess"] != ""
		guess = Integer( params["guess"] )
		message = check_guess( guess )
		params["guess"] = ""
	end
	if params["cheat"] && params["cheat"] == "true"
		message << "<p>#{settings.number}</p>"
	end
	message << "<p>You have #{Ben::Counter.get} guesses remaining</p>"
	erb :index, :locals => {
		:styles => settings.styles,
		:message => message
	}
	#throw params.inspect
end

# TODO
#
# rename this file to hangman.rb
#
# Use routes like '/game/load' and '/game/save' and '/game/init'
# with jquery ajax
#
# cf http://stackoverflow.com/questions/16600420/render-in-html-result-of-ajax-call-with-ruby-sinatra
#   for an example of how this would work
