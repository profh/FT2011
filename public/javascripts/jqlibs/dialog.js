$(function() {
	// Create Measurement Question Form
	$( "#dialog-form" ).css("text-align", "left");	
	$( "#dialog-form" ).dialog({
		autoOpen: false,
		height: 500,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {
		}
	});
	$( "#create-question" ).button().click(function() {
		$( "#dialog-form" ).dialog( "open" );
	});
	
	// Edit Measurement Question Form
	$( "#dialog-edit-question" ).css("text-align", "left");	
	$( "#dialog-edit-question" ).dialog({
		autoOpen: false,
		height: 500,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {	
		}
	});
	
	// Create New Event Form
	$( "#dialog-new-event" ).css("text-align", "left");	
	$( "#dialog-new-event" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 600,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "../events";
		}
	});

	// Create New Location Form
	$( "#dialog-new-location" ).css("text-align", "left");	
	$( "#dialog-new-location" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 550,
		width: 400,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "../events";
		}
	});
	
	// Create New Event Type Form
	$( "#dialog-new-eventtype" ).css("text-align", "left");	
	$( "#dialog-new-eventtype" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 300,
		width: 400,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "../events";
		}
	});	
	
	// Create Organization Form
	$( "#dialog-new-organization" ).css("text-align", "left");	
	$( "#dialog-new-organization" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 380,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "../organizations";
		}
	});
	
	// Create New Organization Type Form
	$( "#dialog-new-organization-type" ).css("text-align", "left");	
	$( "#dialog-new-organization-type" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 380,
		width: 400,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "./";
		}
	});			

	// Create New Checkpoint Form
	$( "#dialog-new-checkpoint" ).css("text-align", "left");	
	$( "#dialog-new-checkpoint" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 400,
		width: 400,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "../checkpoints";
		}
	});	
	
	// Create New Measurement Form
	$( "#dialog-new-measurement" ).css("text-align", "left");	
	$( "#dialog-new-measurement" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 420,
		width: 550,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "../checkpoints";
		}
	});
	
	// Create New Registration Form
	$( "#dialog-new-registration" ).css("text-align", "left");	
	$( "#dialog-new-registration" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 300,
		width: 350,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "../../events";
		}
	});
	
	// Create New Measurement Category Form
	$( "#dialog-new-measurement-category" ).css("text-align", "left");	
	$( "#dialog-new-measurement-category" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 200,
		width: 550,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "../checkpoints";
		}
	});		
	
	// Create Announcements Form
	$( "#dialog-new-announce" ).css("text-align", "left");  
	$( "#dialog-new-announce" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 600,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {
		  window.location.href = "../home";
		}
	});	
	
	// Create User Form
	$( "#dialog-new-user" ).css("text-align", "left");  
	$( "#dialog-new-user" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 440,
		width: 500,
		modal: true,
		buttons: {
		},
		close: function() {
		  window.location.href = "../organizations";
		}
	});		
	
	// Edit Event Form
	$( "#dialog-edit-event" ).css("text-align", "left");	
	$( "#dialog-edit-event" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 620,
		width: 650,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "./";
		}
	});
	
	// Edit Event Type Form
	$( "#dialog-edit-event-type" ).css("text-align", "left");	
	$( "#dialog-edit-event-type" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 350,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "./";
		}
	});
	
	// Edit Location Form
	$( "#dialog-edit-location" ).css("text-align", "left");	
	$( "#dialog-edit-location" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 620,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "./";
		}
	});
	
	// Edit Checkpoint Form
	$( "#dialog-edit-checkpoint" ).css("text-align", "left");	
	$( "#dialog-edit-checkpoint" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 500,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "./";
		}
	});
	
	// Edit Measurement Form
	$( "#dialog-edit-measurement" ).css("text-align", "left");	
	$( "#dialog-edit-measurement" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 450,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "./";
		}
	});	
	
	// Edit Measurement Category Form
	$( "#dialog-edit-measurement-category" ).css("text-align", "left");	
	$( "#dialog-edit-measurement-category" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 250,
		width: 400,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "./";
		}
	});
	
	// Edit Organization Form
	$( "#dialog-edit-organization" ).css("text-align", "left");	
	$( "#dialog-edit-organization" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 380,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "./";
		}
	});
		
	// Edit Organization Type Form
	$( "#dialog-edit-organization-type" ).css("text-align", "left");	
	$( "#dialog-edit-organization-type" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 380,
		width: 400,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "./";
		}
	});
	
	// Edit Announcement Form
	$( "#dialog-edit-announcement" ).css("text-align", "left"); 
	$( "#dialog-edit-announcement" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 500,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {
		  window.location.href = "../..";
		}
	});
	
	// Edit User Form
	$( "#dialog-edit-user" ).css("text-align", "left");	
	$( "#dialog-edit-user" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 600,
		width: 600,
		modal: true,
		buttons: {
		},
		close: function() {
			window.location.href = "../..";
		}
	}); 	
	
	// Take Checkpoint Form
	$( "#dialog-take-checkpoint" ).css("text-align", "left"); 
	$( "#dialog-take-checkpoint" ).dialog({
		autoOpen: true,
		closeOnEscape: true,
		height: 600,
		width: 650,
		modal: true,
		buttons: {
		},
		close: function() {
		  window.location.href = "../../checkpoints";
		}
	}); 	
});