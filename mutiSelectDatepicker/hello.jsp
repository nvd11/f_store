<head>
	<script src="/radprod/resources/js/jquery-2.1.1.js"></script>
	<script src="/radprod/resources/js/jquery-ui-1.11.1.js"></script>
	<script src="/radprod/resources/js/prettify.js"></script>
	<script src="/radprod/resources/jquery-ui.multidatespicker.js"></script>
	
	
	<link rel="stylesheet" href="/radprod/resources/css/jquery-ui.css">
	<link rel="stylesheet" href="/radprod/resources/css/jquery-ui.structure.css">

  <!-- 
  <script src="/radprod/resources/jquery-ui-1.12.0-rc.2/jquery-2.2.4.min.js"></script>
  <script src="/radprod/resources/jquery-ui-1.12.0-rc.2/jquery-ui.min.js"></script>
  <link rel="stylesheet" href="/radprod/resources/jquery-ui-1.12.0-rc.2/jquery-ui.min.css">
  -->
  
</head>


<script type="text/javascript">
	$(function(){
		alert(1);
		$('#text_id').multiDatesPicker();
		$('#text_id2').multiDatesPicker();
		$('#button_id').multiDatesPicker();
		//$("#datepicker").datepicker();
		//$('#text_id').datepicker();
	});
	
</script>

<html>
<body>
<h2>welcome Hello World!!!</h2>

<textarea id="text_id"></textarea>
<input type="text" id="text_id2">
<button type="button" id="button_id">Click Me!</button>

<br/>
<br/>
<br/>
<br/>
<div type="text" id="datepicker"></div>


</body>
</html>
