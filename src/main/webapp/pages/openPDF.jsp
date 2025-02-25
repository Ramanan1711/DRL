<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>HTML to PDF - techumber</title>
	<link rel="stylesheet" type="text/css" href="./css/semantic.css">
</head>
<body>
	<div class="ui page grid">
		<div class="wide column">
			<h1 class="ui header aligned center">HTML to PDF</h1>
			<div class="ui divider hidden"></div>
			<div class="ui segment">
				<div class="ui button aligned center teal" id="create_pdf">Create PDF</div>
				<div class="ui divider"></div>
				<form class="ui form">
					<h4 class="ui dividing header">Personal Information</h4>
					<div class="two fields">
						<div class="field">
							<label for="">First Name</label>
							<input type="text" name="first-name" placeholder="First Name">
						</div>
						<div class="field">
							<label for="">Last Name</label>
							<input type="text" name="last-name" placeholder="First Name">
						</div>
					</div>
					<div class="field">
						<label>Biography</label>
						<textarea></textarea>
					</div>
					<h4 class="ui dividing header">Account Info</h4>
					<div class="two fields">
						<div class="required field">
							<label>Username</label>
							<div class="ui icon input">
								<input type="text" placeholder="Username">
								<i class="user icon"></i>
							</div>
						</div>
						<div class="required field">
							<label>Password</label>
							<div class="ui icon input">
								<input type="password">
								<i class="lock icon"></i>
							</div>
						</div>
					</div>
					<h4 class="ui top attached header">Import Settings</h4>
					<div class="ui bottom attached segment">
						<div class="grouped fields">
							<label for="alone">Would you like us to import your current settings?</label>
							<div class="field">
								<div class="ui  checkbox">
									<input type="radio" checked="" name="import">
									<label>Yes</label>
								</div>
							</div>
							<div class="field">
								<div class="ui  checkbox">
									<input type="radio" name="import">
									<label>No</label>
								</div>
							</div>
						</div>
					</div>
					<h4 class="ui dividing header">Settings</h4>
					<h5 class="ui header">Privacy</h5>
					<div class="field">
						<div class="ui  checkbox">
							<input type="radio" name="privacy">
							<label>Allow <b>anyone</b> to see my account</label>
						</div>
					</div>
					<div class="field">
						<div class="ui  checkbox">
							<input type="radio" name="privacy">
							<label>Allow <b>only friends</b> to see my account</label>
						</div>
					</div>
					<h5 class="ui header">Newsletter Subscriptions</h5>
					<div class="field">
						<div class="ui  checkbox">
							<input type="checkbox" name="top-posts">
							<label>Top Posts This Week</label>
						</div>
					</div>
					<div class="field">
						<div class="ui  checkbox">
							<input type="checkbox" name="hot-deals">
							<label>Hot Deals</label>
						</div>
					</div>
					<div class="ui hidden divider"></div>
					<div class="field">
						<div class="ui checkbox">
							<input type="checkbox" name="hot-deals">
							<label>I agree to the <a href="#">Terms of Service</a>.</label>
						</div>
					</div>
					<div class="ui error message">
						<div class="header">We noticed some issues</div>
					</div>
					<div class="ui submit button blue">Register</div>
				</form>
			</div>
		</div>
	</div>
	<!-- scripts -->
	<script src="./js/jquery-1.11.1.min.js"></script>
	<script type="text/javascript" src="./js/html2canvas.js"></script>
	<script type="text/javascript" src="./js/jspdf.js"></script>
	<script type="text/javascript" src="./js/app.js"></script>
</body>
<script>
var 
form = $('.form'),
cache_width = form.width(),
a4  =[ 595.28,  841.89];  // for a4 size paper width and height
$(document).ready(function(){
	createPDF();
	

$('#create_pdf').on('click',function(){
	$('body').scrollTop(0);
	createPDF();
});
//create pdf
function createPDF(){
	alert('create');
	getCanvas().then(function(canvas){
		var 
		img = canvas.toDataURL("image/png"),
		doc = new jsPDF({
          unit:'px', 
          format:'a4'
        });     
        doc.addImage(img, 'JPEG', 20, 20);
        doc.save('techumber-html-to-pdf.pdf');
        form.width(cache_width);
	});
}

// create canvas object
function getCanvas(){
	form.width((a4[0]*1.33333) -80).css('max-width','none');
	return html2canvas(form,{
    	imageTimeout:2000,
    	removeContainer:true
    });	
}
});
</script>

</html>