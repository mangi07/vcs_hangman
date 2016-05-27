var gameData; // JSON object

$( document ).ready(function() {
    
    console.log( "ready!" );
    checkStatus();

    // Only show when setting difficulty level
    $( "#difficulty-input" ).hide();

    // Registering listeners
    $( "#save-game" ).click( saveGame );
    $( "#load-game" ).click( loadGame );
    $( "#new-game" ).click( newGame );
    $( "#letter-form" ).submit( event, makeGuess );

    function saveGame() {
    	console.log( $( "#save-game" ).text() );
    	$.ajax({
    		type: "GET",
    		url: "/game/save",
    		success: function( data ) {
    			console.log( data );
    		}
    	});
    }

    function loadGame() {
    	console.log( $( "#load-game" ).text() );
    	$.ajax({
    		type: "GET",
    		url: "/game/load",
    		success: function( data ) {
    			gameData = JSON.parse( data );
    			console.log( gameData );
    			showPlayFields();
    			setUpDom( gameData );
    		}
    	});
	}

	function newGame() {
    	console.log( $( "#new-game" ).text() );
    	
    	$( "#difficulty-input" ).show(1000);
    	// get difficulty level from user
    	$( "#difficulty-input" ).submit( event, initGame );
	}

	function initGame() {
		var difficulty = parseInt( $( "#chosen" ).val() );
		$.ajax({
    		type: "GET",
    		url: "/game/new",
    		data: { 'difficulty': difficulty },
    		success: function( data ) {
    			gameData = JSON.parse( data );
    			setUpDom( gameData );
    			console.log( gameData );
    			// We don't need the difficulty input until next time.
    			$( "#difficulty-input" ).hide(1000);
    			showPlayFields();
    		}
    	});
    	// prevent page refresh to preserve jQuery dom manipulations
    	event.preventDefault();
	}

	function makeGuess() {
		var letter = $( "#letter" ).val();
    	$.ajax({
    		type: "GET",
    		url: "/game/guess",
    		data: { 'letter': letter },
    		success: function( data ) {
    			gameData = JSON.parse( data );
    			console.log( gameData );
    			setUpDom( gameData );
    			checkStatus();
    		}
    	});
    	// prevent page refresh to preserve jQuery dom manipulations
    	event.preventDefault();
	}

	function setUpDom( gameData ) {
		$( "#difficulty" ).text( gameData.difficulty );
		$( "#guesses-remaining" ).text( gameData.guesses );
		showWordBlanks( gameData );
		showUsedLetters( gameData );
	}

	function showWordBlanks( gameData ) {
		var str = "";
		for ( var i = 0; i < gameData.difficulty; i++ ) {
			str += " " + gameData.blanks[ i ];
		}
		$( "#word" ).text( str );
	}

	function showUsedLetters( gameData ) {
		var str = "";
		for (var i = 0; i < gameData.used_letters.length; i++ ) {
			str += " " + gameData.used_letters[ i ];
		}
		$( "#used-letters" ).text( str );
	}

	function checkStatus() {
		if ( gameData == undefined ) {
			// hide "Save Game" button, "Guess!" form, and,
			//   "Load Game" button if saved state on sever
			$( "#save-game" ).hide();
			if ( ! gameIsSaved() ) {
				$( "#load-game" ).hide();
			}
			$( "#letter-form" ).hide();
		} else if ( gameData.status == -1 ) {
			getWord();
			clearGame( "YOU LOST!" );
		} else if ( gameData.status == 1 ) {
			clearGame( "YOU WON!" );
		}
	}

	function getWord() {
		$.ajax({
    		type: "GET",
    		url: "/game/reveal",
    		async: false,
    		success: function( data ) {
    			revealWord( data );
    		}
    	});
	}

	function revealWord( word ) {
		alert( word );
		var revealedHTML = "";
		var missedIndices = [];
		for ( var i = 0; i < word.length; i++ ) {
			if ( gameData.blanks[ i ] == '_' ) {
				missedIndices.push( i ); // debug breakpoint
			}
		}
		// craft revealed word with alternating colors and fill in as html in id word
		for ( var j = 0; j < word.length; j++ ) {
			if ( j == missedIndices[ 0 ] ) {
				missedIndices.shift();
				revealedHTML += " <span style='color:#66ffe5'>" + word[ j ] + "</span>";
			} else {
				revealedHTML += " " + word[ j ];
			}
		}
		console.log( revealedHTML );
		$( "#word" ).html( revealedHTML );
	}

	function clearGame( message ) {
		alert( message );
		gameData = undefined;
    	$.ajax({
    		type: "GET",
    		url: "/game/clear",
    		success: function( data ) {
    			alert( data );
    			checkStatus();
    		}
    	});
    	// prevent page refresh to preserve jQuery dom manipulations
    	event.preventDefault();
	}

	function gameIsSaved() {
		response = false;
		$.ajax({
			type: "GET",
			async: false,
			url: "/game/checkSaved",
			success: function( data ) {
				if ( data == "true" ) {
					response = true;
				} else if ( data == "false" ) {
					response = false;
				}
			}
    	});
    	return response;
	}

	function showPlayFields() {
		$( "#save-game" ).show();
		$( "#load-game" ).show();
		$( "#letter-form" ).show();
	}

});

