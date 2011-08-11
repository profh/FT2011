// Number of questions
var count = 0;
var choices_count = 2;
	
// Validate if value contains only digits
function isDigit(argvalue) {
	argvalue = argvalue.toString();
	var validChars = "0123456789";
	var startFrom = 0;
	if (argvalue.substring(0, 2) == "0x") {
	   validChars = "0123456789abcdefABCDEF";
	   startFrom = 2;
	} else if (argvalue.charAt(0) == "0") {
	   validChars = "01234567";
	   startFrom = 1;
	}
	for (var n = 0; n < argvalue.length; n++) {
		if (validChars.indexOf(argvalue.substring(n, n+1)) == -1) return false;
	}
  return true;
}

// Reset choices
var reset_choices = function(){
	// Reset count to 2
	choices_count = 2;
	
	// Empty out div for newform and editform
	$("#choice_list").empty();
	$("#edit_choice_list").empty();
	
	// Append back default stuffs for both divs
	$("#choice_list").append("<div class='button'><a href='#' onclick='add_newform_choices()'>Add Choice</a></div><br /><br />");
	$("#choice_list").append("<div id='newform_multiple_choice_0'>1. <input type='text' id='choices_0' name='choices_0' /> <input type='text' id='points_0' name='points_0' placeholder='Score' style='width:50px' /></div>");
	$("#choice_list").append("<div id='newform_multiple_choice_1'>2. <input type='text' id='choices_1' name='choices_1' /> <input type='text' id='points_1' name='points_1' placeholder='Score' style='width:50px' /></div>");
	$("#edit_choice_list").append("<div class='button'><a href='#' onclick='add_editform_choices()'>Add Choice</a></div><br /><br />");
	$("#edit_choice_list").append("<div id='multiple_choice_0'>1. <input type='text' id='edit_choices_0' name='edit_choices_0' /> <input type='text' id='edit_points_0' name='edit_points_0' placeholder='Score' style='width:50px' /></div>");
	$("#edit_choice_list").append("<div id='multiple_choice_1'>2. <input type='text' id='edit_choices_1' name='edit_choices_1' /> <input type='text' id='edit_points_1' name='edit_points_1' placeholder='Score' style='width:50px' /></div>");
};

// Add more choices (New question form)
var add_newform_choices = function() {
	choices_count++;
	var to_append = "";
	to_append += "<div id='newform_multiple_choice_"+(choices_count-1)+"'>";
	to_append += choices_count + ". <input type='text' id='choices_" + (choices_count-1) + "' name='choices_" + (choices_count-1) + "' /> <input type='text' id='points_" + (choices_count-1) + "' name='points_" + (choices_count-1) + "' style='width:50px' placeholder='Score' />";
	if(choices_count > 2){
		// Append delete button for last choice
		to_append += "<div id='newform_delete_button_"+(choices_count-1)+"' class='button'><a href='#' onclick='delete_newform_choice("+(choices_count-1)+")'>Delete</a></div>";

		// Remove delete button for second last choice (should only have delete buttons for the last choice)
		$("#newform_delete_button_"+(choices_count-2)).remove();	
	}
	to_append += "</div>";
	$("#choice_list").append(to_append);
};

// Add more choices (Edit question form)
var add_editform_choices = function() {
	choices_count++;
	var to_append = "";	
	to_append += "<div id='multiple_choice_"+(choices_count-1)+"'>";
	to_append += choices_count + ". <input type='text' id='edit_choices_" + (choices_count-1) + "' name='edit_choices_" + (choices_count-1) + "' /> <input type='text' id='edit_points_" + (choices_count-1) + "' name='edit_points_" + (choices_count-1) + "' style='width:50px' placeholder='Score' />";
	if(choices_count > 2){
		// Append delete button for last choice
		to_append += "<div id='editform_delete_button_"+(choices_count-1)+"' class='button'><a href='#' onclick='delete_editform_choice("+(choices_count-1)+")'>Delete</a></div>";

		// Remove delete button for second last choice (should only have delete buttons for the last choice)
		$("#editform_delete_button_"+(choices_count-2)).remove();	
	}
	to_append += "</div>";
	$("#edit_choice_list").append(to_append);	
};

// Delete choices (New question form)
var delete_newform_choice = function(choice_id) {
	var prev_id = choice_id - 1;
	$("#newform_multiple_choice_"+choice_id).remove();
	if(prev_id > 1){
		$("#newform_multiple_choice_"+prev_id).append(" <div id='newform_delete_button_"+prev_id+"' class='button'><a href='#' onclick='delete_newform_choice("+prev_id+")'>Delete</a></div>");
	}
	choices_count--;
};

// Delete choices (Edit question form)
var delete_editform_choice = function(choice_id) {
	var prev_id = choice_id - 1;
	$("#multiple_choice_"+choice_id).remove();
	if(prev_id > 1){
		$("#multiple_choice_"+prev_id).append(" <div class='button'><a href='#' onclick='delete_editform_choice("+prev_id+")'>Delete</a></div>");
	}
	choices_count--;
};

// Load questions from database
var load_question = function(type_val, qn_val, complete_score, max_length_val, choices_val, points_val, scale1description_val, scale10description_val){
	if(type_val == "1"){
		$("#all_questions").data(count+"", { type: type_val, question: qn_val, completion_score: complete_score, max_length: max_length_val });

	}else if(type_val == "2" || type_val == "3"){
		var choices_arr = choices_val.split("+");
		var points_arr = points_val.split("+");
		$("#all_questions").data(count+"", { type: type_val, question: qn_val, choices: choices_arr, points: points_arr });

	}else if(type_val == "4"){
		$("#all_questions").data(count+"", { type: type_val, question: qn_val, completion_score: complete_score, scale1description: scale1description_val, scale10description: scale10description_val });

	}
	
	// Increment question count
	count++;
	
	// Display preview
	display_questions();
};

// Display questions
var display_questions = function() {
	$("#all_questions").empty(); // clear div contents
	choices_count = 2; // reset number of choices to display for Multiple Choice & Mulitple Select questions
	
	$.each($("#all_questions").data(), function(key, value) {
		// Stuff to append to all_questions div
		var append_content = "";
		
		// Style each question with form border
		append_content += "<div class='form_border'>";
		
		// Append EDIT & DELETE buttons
		append_content += "<br />";
		append_content += "<button onclick='edit_question(" + key + ")' class='button'>EDIT</button>";
		append_content += "<button onclick='delete_question(" + key + ")' class='button'>DELETE</button>";
	
		// Append form element
		if($("#all_questions").data(key).type == "1"){
			// Append question text & completion score
			append_content += "<div class='form_label'>" + $("#all_questions").data(key).question + " (Completion Score: " + $("#all_questions").data(key).completion_score + ")</div>";
			// Append text box
			append_content += "<input type='text' maxlength='" + $("#all_questions").data(key).max_length + "' />";

			
		}else if($("#all_questions").data(key).type == "2"){
			// Append question text
			append_content += "<div class='form_label'>" + $("#all_questions").data(key).question + "</div>";			

			// Append radio buttons & points of each option
			var choice_count = $("#all_questions").data(key).choices.length;
			var choice_list = $("#all_questions").data(key).choices;
			var points_list = $("#all_questions").data(key).points;
			var i = 0;
			while(i < choice_count){
				append_content += "<input type='radio' name='choices' value='" + choice_list[i] + "' /> " + choice_list[i] + " (Points: " + points_list[i] + ")<br />";
				i++;
			}

		}else if($("#all_questions").data(key).type == "3"){
			// Append question text
			append_content += "<div class='form_label'>" + $("#all_questions").data(key).question + "</div>";		
			
			// Append checkboxes & points of each option
			choices_count = $("#all_questions").data(key).choices.length;
			var choice_list = $("#all_questions").data(key).choices;
			var points_list = $("#all_questions").data(key).points;
			var i = 0;		
			while(i < choices_count){
				append_content += "<input type='checkbox' name='selection' value='" + choice_list[i] + "' /> " + choice_list[i] + " (Points: " + points_list[i] + ")<br />";
				i++;
			}

		}else if($("#all_questions").data(key).type == "4"){
			// Append question description
			append_content += "<div class='form_label'>On a scale of 1 to 10, <b>1</b> being <b>" + $("#all_questions").data(key).scale1description + 
								"</b> and <b>10</b> being <b>" + $("#all_questions").data(key).scale10description + "</b>:</div>"
			// Append question text
			append_content += "<div class='form_label'>" + $("#all_questions").data(key).question + " (Completion Score: " + $("#all_questions").data(key).completion_score + ")</div>";			
			
			// Readonly text field showing value selected by jQuery slider
			append_content += "<div class='form_label'>Your answer: <input type='text' readonly='readonly' id='slider_value_" + key + "' class='readonly_text' style='border:0' /></div>";
			
			// jQuery slider bar div
			append_content += "<div id='slider_bar_" + key + "'></div>";
		}

		// End of form border
		append_content += "</div>";
		
		// Append content to div
		$("#all_questions").append(append_content);		
		
		// Create jQuery slider bar if it's a scale question
		if($("#all_questions").data(key).type == "4"){
			call_slider(key); 
		}
	});
};

// Edit question
var edit_question = function(key) {
	// Clear div content
	$("#dialog-edit-question").empty();

	// Get question details
	var question_type = $("#all_questions").data(key+"").type;
	var question = $("#all_questions").data(key+"").question;	

	if(question_type == "1"){ // Short Answer
		var max_length = $("#all_questions").data(key+"").max_length;
		var completion_score = $("#all_questions").data(key+"").completion_score;
		
	}else if(question_type == "2" || question_type == "3"){ // Multiple Choice or Multiple Select
		choices_count = $("#all_questions").data(key+"").choices.length;
		var choice_list = $("#all_questions").data(key+"").choices;
		var points_list = $("#all_questions").data(key+"").points;
		var completion_score = "0";
	
	}else if(question_type == "4"){ // Scale
		var scale1description = $("#all_questions").data(key+"").scale1description;
		var scale10description = $("#all_questions").data(key+"").scale10description;
		var completion_score = $("#all_questions").data(key+"").completion_score;
	}
	
	// Populate edit form
	var form_content = "";
	
	form_content += "<p>All form fields are required.</p>";
	
	//-start form tag
	form_content += "<form id='edit_question_form'>";
	
	//-dropdown menu for question type
	form_content += "<div class='form_label'>What type of question?</div>";
	form_content += "<select id='edit_question_type' name='edit_question_type' onchange='edit_question_type_onchange()'>";
	form_content += "<option value=''>- Select One -</option>";
	var option_count = 1;	
	while(option_count <= 4){
		var option_selected = "";
		if(question_type == (option_count+"")){
			option_selected = " selected='selected'";
		}
		form_content += "<option value='" + option_count + "'" + option_selected + ">";
		if(option_count == 1){
			form_content += "Short Answer</option>";
		}else if(option_count == 2){
			form_content += "Multiple Choice</option>";
		}else if(option_count == 3){
			form_content += "Multiple Select</option>";
		}else if(option_count == 4){
			form_content += "Scale</option>";
		}
		option_count += 1;
	}
	form_content += "</select>";
	
	//-question text box
	form_content += "<div class='form_label'>Question</div>"; 
	form_content += "<input type='text' id='edit_question' name='edit_question' style='width:500px' value='" + question + "' />";
	
	//-completion score text box
	form_content += "<div class='form_label completion_score'>Completion Score</div>";
	form_content += "<div class='completion_score'><input type='text' id='edit_completion_score' name='edit_completion_score' style='width:80px' value='" + completion_score + "' /></div>";
	
	//-max length text box
	form_content += "<div class='form_label max_length'>Max Length</div>";
	if(question_type == 1){
		form_content += "<div class='max_length'><input type='text' id='edit_max_length' name='edit_max_length' style='width:50px' value='" + max_length + "' /> characters</div>";
	}else{
		form_content += "<div class='max_length'><input type='text' id='edit_max_length' name='edit_max_length' style='width:50px' /> characters</div>";
	}
	
	//-choices text boxes
	form_content += "<div class='form_label choices'>Choices</div>";
	form_content += "<div class='choices' id='edit_choice_list'>";
	form_content += "<div class='button'><a href='#' onclick='add_editform_choices()'>Add Choice</a></div><br /><br />";
	if(question_type == 2 || question_type == 3){
		var i = 0;		
		while(i < choices_count){
			form_content += "<div id='multiple_choice_" + i + "'>";
			form_content += i+1 + ". <input type='text' id='edit_choices_" + i + "' name='edit_choices_" + i + "' value='" + choice_list[i] + "' /> <input type='text' id='edit_points_" + i + "' name='edit_points_" + i + "' value='" + points_list[i] + "' style='width:50px' placeholder='Score' />";
			if((i == choices_count-1) && (i > 1)){
				form_content += " <div class='button'><a href='#' onclick='delete_editform_choice("+i+")'>Delete</a></div>";
			}
			form_content += "</div>";
			i++;
		}
		form_content += "</div>";
	}else{
		var i = 0;
		choices_count = 2;
		while(i < choices_count){
			form_content += i+1 + ". <input type='text' id='edit_choices_" + i + "' name='edit_choices_" + i + "' />  <input type='text' id='edit_points_" + i + "' name='edit_points_" + i + "' placeholder='Score' style='width:50px' /><br />";
			i++;
		}
		form_content += "</div>";
	}
	
	//-scale description text boxes
	form_content += "<div class='form_label scale_type'>Scale Type</div>";
	form_content += "<div class='scale_type'>";
	form_content += "<table width='300px' align='center'><tr><td><b>1</b></td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td><b>10</b></td></tr></table>";
	form_content += "<table>";
	form_content += "<tr>";
	form_content += "<td>Describe (1):</td>";
	if(question_type == 4){
		form_content += "<td><input type='text' id='edit_scale_1_description' name='edit_scale_1_description' size='36' value='" + scale1description + "' /></td>";
	}else{
		form_content += "<td><input type='text' id='edit_scale_1_description' name='edit_scale_1_description' size='36' /></td>";
	}
	form_content += "</tr>";
	form_content += "<tr>";
	form_content += "<td>Describe (2):</td>";
	if(question_type == 4){
		form_content += "<td><input type='text' id='edit_scale_10_description' name='edit_scale_10_description' size='36' value='" + scale10description + "' /></td>";
	}else{
		form_content += "<td><input type='text' id='edit_scale_10_description' name='edit_scale_10_description' size='36' /></td>";
	}
	form_content += "</tr>";
	form_content += "</table>";
	form_content += "</div>";
	form_content += "<br /><br /><hr style='margin-bottom:5px' />";
	form_content += "<button onclick='return update_question(" + key + ")' class='button'>Save Question</button>";
	
	form_content += "</form>";
	
	// Add HTML content to edit form div
	$("#dialog-edit-question").append(form_content);
	
	// Show only applicable form elements depending on question type
	if(question_type == 1){
		$(".max_length").css("display", "block");
		$(".choices").css("display", "none");
		$(".scale_type").css("display", "none");
		$(".completion_score").css("display", "block");
	}else if(question_type == 2 || question_type == 3){
		$(".max_length").css("display", "none");
		$(".choices").css("display", "block");
		$(".scale_type").css("display", "none");
		$(".completion_score").css("display", "none");
	}else if(question_type == 4){
		$(".max_length").css("display", "none");
		$(".choices").css("display", "none");
		$(".scale_type").css("display", "block");
		$(".completion_score").css("display", "block");
	}
	
	// Open edit form
	$("#dialog-edit-question").dialog("open");
};

// Edit question form: Change form fields accordingly based on question type selected
var edit_question_type_onchange = function(){
	if($("#edit_question_type option:selected").val() == ""){
		$(".max_length").css("display","none");
		$(".choices").css("display","none");
		$(".scale_type").css("display","none");
		$(".completion_score").css("display", "none");
		
	}else if($("#edit_question_type option:selected").val() == "1"){
		$(".max_length").css("display","block");
		$(".choices").css("display","none");
		$(".scale_type").css("display","none");	
		$(".completion_score").css("display", "block");

	}else if(($("#edit_question_type option:selected").val() == "2") || ($("#edit_question_type option:selected").val() == "3")){
		$(".max_length").css("display","none");
		$(".choices").css("display","block");
		$(".scale_type").css("display","none");
		$(".completion_score").css("display", "none");
		
	}else if($("#edit_question_type option:selected").val() == "4"){
		$(".max_length").css("display","none");
		$(".choices").css("display","none");
		$(".scale_type").css("display","block");
		$(".completion_score").css("display", "block");	
	}
};

// Update question
var update_question = function(key){
	// Client-side validation
	if($("#edit_question_type").val() == "" || $("#edit_question").val() == "" ) return false;
	if($("#edit_question_type").val() == "1"){
		if($("#edit_max_length").val() == "" || $("#edit_max_length").val() == "0" || $("#edit_completion_score").val() == "" || $("#edit_completion_score").val() == "0"){
			return false; //prevent blank or '0' value
		}else{
			if(isDigit($("#edit_max_length").val()) == false || isDigit($("#edit_completion_score").val()) == false) return false; //ensure value is a positive digit
		}
	}else if($("#edit_question_type").val() == "2" || $("#edit_question_type").val() == "3" ){
		if($("#edit_choices_0").val() == "" || $("#edit_choices_1").val() == "" || $("#edit_points_0").val() == "" || $("#edit_points_1").val() == "") return false
		
	}else if($("#edit_question_type").val() == "4"){
		if($("#edit_scale_1_description").val() == "" || $("#edit_scale_10_description").val() == "" || $("#edit_completion_score").val() == "" || $("#edit_completion_score").val() == "0" || isDigit($("#edit_completion_score").val()) == false) return false;
	}
	
	// Remove old data
	$("#all_questions").removeData(key+"");

	// Store data
	if($("#edit_question_type").val() == "1"){
		$("#all_questions").data(key+"", 
		{ type: $("#edit_question_type").val(), question: $("#edit_question").val(), max_length: $("#edit_max_length").val(), completion_score: $("#edit_completion_score").val() });
	}else if(($("#edit_question_type").val() == "2") || ($("#edit_question_type").val() == "3")){
		var choices_arr = [];
		var points_arr = [];
		var i = 0;
		while($("#edit_choices_"+i).length != 0){	// loop as long the form element exists
			if($("#edit_choices_"+i).val() == "" || $("#edit_points_"+i).val() == "") return false;
			choices_arr.push($("#edit_choices_"+i).val());
			points_arr.push($("#edit_points_"+i).val());
			i++;
		}
		$("#all_questions").data(key+"", 
		{ type: $("#edit_question_type").val(), question: $("#edit_question").val(), choices: choices_arr, points: points_arr });
	}else if($("#edit_question_type").val() == "4"){
		$("#all_questions").data(key+"", 
		{ type: $("#edit_question_type").val(), question: $("#edit_question").val(), scale1description: $("#edit_scale_1_description").val(), scale10description: $("#edit_scale_10_description").val(), completion_score: $("#edit_completion_score").val() });
	}
	
	// Display preview
	display_questions();
	
	// Close edit form
	$("#dialog-edit-question").dialog("close");
	
	return false;	
};

// Delete question
var delete_question = function(key) {
	$("#all_questions").removeData(key+"");
	display_questions();
};

$(document).ready(function(){
	// On value change (question_type select box)
	$(".target").change(function() {  
		if($("select option:selected").val() == ""){
			$(".max_length").css("display","none");
			$(".choices").css("display","none");
			$(".scale_type").css("display","none");
			$(".completion_score").css("display","none");
    
		}else if($("select option:selected").val() == "1"){
			$(".max_length").css("display","block");
			$(".choices").css("display","none");
			$(".scale_type").css("display","none");
			$(".completion_score").css("display","block");

		}else if(($("select option:selected").val() == "2") || ($("select option:selected").val() == "3")){
			$(".max_length").css("display","none");
			$(".choices").css("display","block");
			$(".scale_type").css("display","none");
			$(".completion_score").css("display","none");
    
		}else if($("select option:selected").val() == "4"){
			$(".max_length").css("display","none");
			$(".choices").css("display","none");
			$(".scale_type").css("display","block"); 
			$(".completion_score").css("display","block");
		}
	});
	
	$("#add_question").button().click(function() {
		// Client-side validation
		if($("#question_type").val() == "" || $("#question").val() == "" ) return false;
		if($("#question_type").val() == "1"){
			if($("#max_length").val() == "" || $("#max_length").val() == "0" || $("#completion_score").val() == "" || $("#completion_score").val() == "0"){
				return false;
			}else{
				if(isDigit($("#max_length").val()) == false || isDigit($("#completion_score").val()) == false) return false;
			}
		}else if($("#question_type").val() == "2" || $("#question_type").val() == "3" ){
			if($("#choices_0").val() == "" || $("#choices_1").val() == "" || $("#points_0").val() == "" || $("#points_1").val() == "" ){
				return false;
			}else{
				if(isDigit($("#points_0").val()) == false || isDigit($("#points_1").val()) == false) return false;
			}
			
		}else if($("#question_type").val() == "4"){
			if($("#scale_1_description").val() == "" || $("#scale_10_description").val() == "" || $("#completion_score").val() == "" || $("#completion_score").val() == "0" || isDigit($("#completion_score").val()) == false) return false;
		}
		
		// Valid fields filled up, process data entered
		count = count + 1;
		
		// Store data
		if($("#question_type").val() == "1"){
			$("#all_questions").data(count+"", 
			{ type: $("#question_type").val(), question: $("#question").val(), max_length: $("#max_length").val(), completion_score: $("#completion_score").val() });

		}else if(($("#question_type").val() == "2") || ($("#question_type").val() == "3")){			
			var choices_arr = [];
			var points_arr = [];
			var j = 0;
			while($("#choices_"+j).length != 0){	// loop as long the form element exists
				if($("#choices_"+j).val() == "" || $("#points_"+j).val() == "") return false;
				choices_arr.push($("#choices_"+j).val());
				points_arr.push($("#points_"+j).val());
				j++;
			}			
			$("#all_questions").data(count+"", 
			{ type: $("#question_type").val(), question: $("#question").val(), choices: choices_arr, points: points_arr });

		}else if($("#question_type").val() == "4"){
			$("#all_questions").data(count+"", 
			{ type: $("#question_type").val(), question: $("#question").val(), scale1description: $("#scale_1_description").val(), scale10description: $("#scale_10_description").val(), completion_score: $("#completion_score").val() });
		}
		
		// Display preview
		display_questions();
		
		// Clear form
		$("#question").val("");
		$("#completion_score").val("");
		$("#max_length").val("");
		$("#scale_1_description").val("");
		$("#scale_10_description").val("");		
		// Empty list of choices, reset back to default of 2 choices for Multiple Choice & Select questions
		reset_choices();
		
		return false;
	});		
	
	// When 'Save Changes' button is clicked
	$("#questions_submit").submit(function() {
		var params = "";
		var i = 1;
		$.each($("#all_questions").data(), function(key, value) {		
			if(i!=1) params += ";";

			if($("#all_questions").data(key+"").type == "1"){
				params += "id=" + key + 
					"&type=" + $("#all_questions").data(key+"").type + 
					"&question=" + $("#all_questions").data(key+"").question + 
					"&max_length=" + $("#all_questions").data(key+"").max_length +
					"&completion_score=" + $("#all_questions").data(key+"").completion_score;
			}

			if($("#all_questions").data(key+"").type == "2" || $("#all_questions").data(key+"").type == "3"){
				params += "id=" + key + 
				"&type=" + $("#all_questions").data(key+"").type + 
				"&question=" + $("#all_questions").data(key+"").question +
				"&choices=" + $("#all_questions").data(key+"").choices +
				"&points=" + $("#all_questions").data(key+"").points;
			}

			if($("#all_questions").data(key+"").type == "4"){
				params += "id=" + key + 
				"&type=" + $("#all_questions").data(key+"").type + 
				"&question=" + $("#all_questions").data(key+"").question +
				"&completion_score=" + $("#all_questions").data(key+"").completion_score +
				"&scale1description=" + $("#all_questions").data(key+"").scale1description +
				"&scale10description=" + $("#all_questions").data(key+"").scale10description;
			}
			i++;
		});
		
		$("#question_list").val(params);
		return true;
	});
});