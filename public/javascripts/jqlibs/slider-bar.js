var call_slider = function(response_id) {
	$( "#slider_bar_"+response_id ).slider({
		range: "max",
		min: 1,
		max: 10,
		value: 5,
		slide: function( event, ui ) {
			$("#slider_value_"+response_id ).val( ui.value );
		}
	});
	$( "#slider_value_"+response_id ).val( $( "#slider_bar_"+response_id ).slider( "value" ) );
};

var set_slider_value = function(response_id, new_value){
	$( "#slider_bar_"+response_id ).slider( "value", new_value );
	$( "#slider_value_"+response_id ).val( $( "#slider_bar_"+response_id ).slider( "value" ) );
};