var gameData; // JSON object

$( document ).ready(function() {
    
    console.log( "ready!" );
    var guesses = 5;

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
    		}
    	});
    	// prevent page refresh to preserve jQuery dom manipulations
    	event.preventDefault();
	}

	function setUpDom( gameData ) {
		$( "#difficulty" ).text( gameData.difficulty );
		$( "#guesses-remaining" ).text( gameData.guesses );
		showWordBlanks( gameData );
		// show used letters here
		// add logic here to check status for win/loss
	}

	// modify this when we get to the point where we're actually dealing with the word's current guessed state
	function showWordBlanks( gameData ) {
		var str = "";
		for ( var i = 0; i < gameData.difficulty; i++ ) {
			str += " " + gameData.blanks[ i ];
		}
		$( "#word" ).text( str );
	}

});

