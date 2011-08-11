var page_load_count = 0;

//load added items
var populate_count = 0;
var populate_existing_item = function(item) {
	/* 	HACK FOR PAGES THAT HAVE EDIT FORMS
			page loads twice due to jQuery dialog form causing list of selected measurements to populate twice
			page_load_count check ensures that this function only runs once to prevent the duplicate population
	*/
	if(page_load_count != 1){
		$("#selected_measurements").data(populate_count+"", item);
		populate_count++;
	}
};

//delete data
var delete_item = function(key) {
	$("#selected_measurements").removeData(key+"");
	display_selected_measurements();
};

//display selected item by looping through each element in data object
var display_selected_measurements = function() {
	$("#selected_measurements").empty();
	$.each($("#selected_measurements").data(), function(key, value) {
		$("#selected_measurements").append("<div class='selected_item'>" + $("#selected_measurements").data(key) +  " <a href='#autocomplete_measurements' title='Delete Item' alt='Delete Item' onclick='delete_item(" + key + ")'>x</a></div>");
	});
};

//populate selected item by looping through each element in data object
var populate_selected_measurements = function() {
	/* 	HACK FOR PAGES THAT HAVE EDIT FORMS
			page loads twice due to jQuery dialog form causing list of selected measurements to populate twice
			page_load_count check ensures that this function only runs once to prevent the duplicate population
	*/
	if(page_load_count == 0){
		page_load_count = 1;
		
		$("#selected_measurements").empty();
		$.each($("#selected_measurements").data(), function(key, value) {
			$("#selected_measurements").append("<div class='selected_item'>" + $("#selected_measurements").data(key) +  " <a href='#autocomplete_measurements' title='Delete Item' alt='Delete Item' onclick='delete_item(" + key + ")'>x</a></div>");
		});
	}
};	

//on document load
$(document).ready(function(){
	var count = populate_count
	
    $.ajax({
        type: "POST",
        url: "/events/measurements",
        dataType: "json",
        data: "{}",
        contentType: "application/json; charset=utf-8",
        success: function(data){
            $("#autocomplete_measurements").autocomplete({
                minLength: 0,
				
				//data source for helper list
                source: data,
				
				//when an item is selected from the helper list
				select: function(event, ui){
					//save selected item to data object
					$("#selected_measurements").data(count+"", ui.item.value);

					//display selected item
					page_load_count = 0;
					display_selected_measurements();

					//increment item count
					count++;
				}
            });
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert(textStatus);
        }
    });
	
	//send data containing selected items as comma delimited string of values
	$("#event_form").submit(function() {
		var item_string = "";
		var x = 0;
		$.each($("#selected_measurements").data(), function(key, value) {
			if(x != 0){
				item_string += ",";
			}
			item_string += value;
			x++;
		});		
		$("#selected_measurements_string").val(item_string);
	});
});
