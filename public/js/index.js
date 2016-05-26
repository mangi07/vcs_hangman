$( document ).ready(function() {
    
    console.log( "ready!" );
    var guesses = 5;

    // Only show when setting difficulty level
    $( "#difficulty-input" ).hide();

    // Registering listeners
    $( "#save-game" ).click( saveGame );
    $( "#load-game" ).click( loadGame );
    $( "#new-game" ).click( newGame );

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
    			console.log( data );
    			// call function that loads data into html
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
		var word = "not set by response";
		$.ajax({
    		type: "GET",
    		url: "/game/new",
    		data: { 'difficulty': difficulty },
    		success: function( data ) {
    			setUpDom( difficulty );
    			console.log( data );
    			// We don't need the difficulty input until next time.
    			$( "#difficulty-input" ).hide(1000);
    			// call function that loads data into html
    		}
    	});
    	// prevent page refresh to preserve jQuery dom manipulations
    	event.preventDefault();
	}

	function setUpDom( difficulty ) {
		$( "#difficulty" ).text( difficulty );
		guesses = 5;
		$( "#guesses-remaining" ).text( guesses );
		showWordBlanks( difficulty );
	}

	function showWordBlanks( difficulty ) {
		var str = "";
		for ( var i = 0; i < difficulty; i++ ) {
			str += " _ ";
		}
		$( "#word" ).text( str );
	}

});

