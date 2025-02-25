<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Tooling Receiving Inspection</title>
<link href="./css/tiim.css" rel="stylesheet" type="text/css"></link>
<script type="text/javascript" src="./js/jquery-1.7.2.min.js"></script> 
<link rel="stylesheet" href="./css/bootstrap.min.css">
<!-- <script type="text/javascript" src="./js/SampleGrid.js"></script>  -->

<script type="text/javascript" src="./js/jquery.alerts.js"></script>
<link href="./css/jquery.alerts.css" rel="stylesheet" type="text/css">
 <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link href="./auto/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/> 
<link href="./auto/themes/base/jquery-ui-1.8.css" rel="stylesheet" type="text/css"/> 
<script type="text/javascript" src="./auto/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="./auto/jquery-ui-1.8.18.min.js"></script>

<script>
$(document).ready(function(){ 
	
	
	 $('#receivingInspection input[type=text]').live("keypress", function(event){
	    	
	    	var pattern = /[a-zA-Z]+/g;
	   		var findFocusId =  $(this).attr('id');	
	   		findFocusId = findFocusId.match(pattern);
	   		switch($.trim(findFocusId))
	   		{		   		   
				case "acceptedQty":
			   		
	   				return (event.which != 8 && event.which != 0 && (event.which < 48 || event.which > 57)) ? false : true;
	   			break;
				case "rejectedQty":
	
					return (event.which != 8 && event.which != 0 && (event.which < 48 || event.which > 57)) ? false : true;
				break;
				
	   		}
   });
	 
	   $("#acceptedQty").keypress(function(e){
		   var code = e.keyCode || e.which;
	 	  	  if(code == 13 || code == 9)
	 	  	  {	 	  		
	 	  		alert($("#acceptedQty").val());
	 	  	  }     	  	 
	         });
	   
	   $("#acceptedQty").keydown(function(e) {
		    var code = e.keyCode || e.which;

		    if (code === 9) {  
		        e.preventDefault();
		        var receivedQuantity = $("#receivedQuantity").text();
		        rejectedQty = parseInt(receivedQuantity) - parseInt($("#acceptedQty").val());
		    	 $("#rejectedQty").val(rejectedQty);
		    	 
		    }
		});
	 
	$("#requestId").autocomplete({
	    source: function (request, response) {
	        $.getJSON("${pageContext. request. contextPath}/autoReciveRequest.jsf", {
	           // term: extractLast(request.term)
	        	requestId: $("#requestId").val()
	        }, response).success(function(data) {
                if(data.length == 0)
                {
                	 $("#autoStatus").html("Data not Available");
                }
             });
	    },
	    search: function () {  // custom minLength
	       	
	    	$("#grnSatus").hide();
	    	
	    },
	    focus: function () {
	        // prevent value inserted on focus
	        return false;
	    },
	    autoFocus: true,
	    minLength: 1,
	    select: function (event, ui) {
	    	 $("#autoStatus").html("");
	    	funLoadInspectionDetails() ;
	    }
	 });  
	
	
	$("#srchMinProductName").autocomplete({
	    source: function (request, response) {
	        $.getJSON("${pageContext. request. contextPath}/autoReciveRequestDrawingNo.jsf", {
	           // term: extractLast(request.term)
	        	drawingNo: $("#srchMinProductName").val()
	        }, response).success(function(data) {
                if(data.length == 0)
                {
                	 $("#autoStatus").html("Data not Available");
                }
             });
	    },
	    search: function () {  // custom minLength
	       	
	    	$("#grnSatus").hide();
	    	
	    },
	    focus: function () {
	        // prevent value inserted on focus
	        return false;
	    },
	    autoFocus: true,
	    minLength: 1,
	    select: function (event, ui) {
	    	// $("#autoStatus").html("");
	    	 $("#srchMinProductName").val(ui.item.id);
		     funSearchMinProductName(ui.item.id);
	    }
	 });  
	
});

 function Init()
 {	
	$("#loadoverlay").hide();
	$("#ajaxLoading").hide();
	var msg = $("#message").val();
	if(msg != "")  
	{    
		$("#msg").fadeIn(300);	   
    }
 }

 function funLoadInspectionDetails()
 { 
	 $("#toolingInspectionId").val("0");
	 $("#acceptedQty").val("0");
	 $("#rejectedQty").val("0");
	 $("#frmInspection").attr("action","fetchToolingReceiveInspection.jsf");                 
	 $("#frmInspection").submit();
 }

 function trim(stringTrim)
 {
 	return stringTrim.replace(/^\s+|\s+$/g,"");
 }
 
 function showimg()
 {
 	$("#ajaxLoading").show();  
 }
 
 function processInspection(val)
 {
	 var inspectionReportNo = $("#inspectionReportNo").val();
	 var requestId = $("#requestId").val();
	 var acceptedQty = $("#acceptedQty").val();
	 var rejectedQty = $("#rejectedQty").val();
	 var receivedQuantity = $("#receivedQuantity").text();
	 if(inspectionReportNo == "")
     {        	
		    jAlert('Please Enter the Report No', 'Inspection Report No is Empty', function(){	
		    	$("#inspectionReportNo").focus();						  			    	 
	        });	
		   return false;
     }
	 else if(acceptedQty == "")
	 {
		 jAlert('Please Enter the Accepted Qty', 'Accepted Qty is Empty', function(){	
		    	$("#acceptedQty").focus();						  			    	 
	        });	
		   return false;
	 }else if(parseInt(receivedQuantity) < parseInt(acceptedQty))
	 {
		 jAlert('Accepted Qty should be less than Received Qty', 'Invalid Accepted Qty', function(){	
		    	$("#acceptedQty").focus();						  			    	 
	        });	
		   return false;
	 }
     else if(requestId == "")
     {
    	 jAlert('Please Enter the Request Id', 'Request Id is Empty');
    	 $("#requestId").focus();		    		
		 return false;		
     }
     else
     {
    	 rejectedQty = parseInt(receivedQuantity) - parseInt(acceptedQty);
    	 $("#rejectedQty").val(rejectedQty);
    	 if(parseInt(rejectedQty) > 0)
    	 {
    		 var rejectedSerialNumber = $("#rejectedSerialNumber").val();
    		 if(rejectedSerialNumber == null || rejectedSerialNumber == "")
    		 {
    			 $("#inspectionStatus1").val("Rejected");
    			 jAlert('Please enter Rejected serial number', 'Rejected Serial Number is empty!', function(){	
    			    	$("#rejectedSerialNumber").focus();						  			    	 
    		        });	
    			   return false;
    		  }
    	 }
    	// else
    	 {
    		  // alert($("#serilaFlag").val()+", "+$("#approvedQty1").val());
    		 $("#ajaxLoading").fadeIn();  
    		 if(($("#serilaFlag").val() == 1) && ($("#approvedQty1").val() == null))
			 {
				 jAlert('Please Selecte serial number for Accepted/Rejected', 'Serial Numbers are empty!', function(){	
					 getSerialNumber();		  			    	 
 		        });	
 			   return false;
			 }
    		 else
    		{
	    		 if(val == "Save")
	    		 {
	    			 $("#toolingInspectionId").val("0");
	    			     				
	    				 $("#loadoverlay").fadeIn();
	    				 $("#frmInspection").attr("action","addToolingReceiveInspection.jsf");  
	    				 $("#frmInspection").submit();
	    		 	 
	    		 }
	    		 else
	    		 {
	    			 $("#loadoverlay").fadeIn();
	    			$("#frmInspection").attr("action","updateToolingInspection.jsf");
	    			$("#frmInspection").submit();
	    		 }
    		}
    		 
    	}
		 
     }
 }
 
 function funToolingList()
 {
	 $("#toolingInspectionId").val("0");
	 $("#inspectionReportNo").val("0");
	 $("#requestId").val("0");
	 $("#acceptedQty").val("0");
	 $("#rejectedQty").val("0");
	 $("#loadoverlay").fadeIn();  
	 $("#ajaxLoading").fadeIn();   	 			                    	                  
	 $("#frmInspection").attr("action","showToolingReceiveInspection.jsf");   	                
     $("#frmInspection").submit();
 }
 
 function funTypeRequestNo(evt,obj)
 {
	   var charCode = (evt.which) ? evt.which : evt.keyCode ;  
	   if(charCode != 8 && charCode != 0 && ((charCode < 48) || (charCode > 57)))
	   {
		   return false;   
	   }
	   else
	   {
		   return true;
	   }
 }
 
 function funTypeReportNo(evt,obj)
 {
	   var charCode = (evt.which) ? evt.which : evt.keyCode ;  
	   if(charCode != 8 && charCode != 0 && ((charCode < 48) || (charCode > 57)))
	   {
		   return false;
	   }
	   else
	   {
		   return true;
	   }
}
 
 function funClear()
 {
	 $("#toolingInspectionId").val("0");
	 $("#inspectionReportNo").val("0");
	 $("#requestId").val("0");
	 $("#frmInspection").attr("action","showAddToolingReceiveInspection.jsf");   	                
     $("#frmInspection").submit();
 }
 
 function funSearchMinProductName(drawingNumber)
 {
	 $.ajax({
			dataType : 'html',
	        url : "${pageContext.request.contextPath}/getReceivingProductDetail.jsf?drawingNumber="+drawingNumber,
	        type : "POST",
	        success : function(result) 
	        {
	  		   if(result != "")
	    	   {	
	  			  $("#listProjectNames").html(result); 
	  			//  $("#waitloadingProductName").hide();
	    	   }
	        }
	    });
 }
 
 function getSerialNumber()
 {
	 var receivedQty = $("#hidReceivedQty").val();
	 var lotNumber = $("#lotNumber").val();
	 if($("#btnProcess").val() == "Update")
	 {
		 $.ajax({
				dataType : 'html',
		        url : "${pageContext.request.contextPath}/getUpdatedSerialNumberDetails.jsf?lotNumber="+lotNumber,
		        type : "POST",
		        success : function(result) 
		        {
		  		   if(result != "")
		    	   {	
		  			 $("#ajaxLoading").hide();
		  		     $("#serialNumberDialog").fadeIn(300);  
		  			  $("#listSerialNumber").html(result); 
		  			//  $("#waitloadingProductName").hide();
		    	   }
		        }
		    });
	 }else
	 {
		 $.ajax({
				dataType : 'html',
		        url : "${pageContext.request.contextPath}/getSerialNumberDetails.jsf?receivedQty="+receivedQty,
		        type : "POST",
		        success : function(result) 
		        {
		  		   if(result != "")
		    	   {	
		  			 $("#ajaxLoading").hide();
		  		     $("#serialNumberDialog").fadeIn(300);  
		  			  $("#listSerialNumber").html(result); 
		  			//  $("#waitloadingProductName").hide();
		    	   }
		        }
		    });
	}
	 
	 
 }
 
 function hideSerialNumberDialog()
 {
	 var goodQty = $('.approvedQty:checkbox:checked').length;
		 
	 $("#acceptedQty").val(goodQty);
	 var returnQty = $("#hidReceivedQty").val();
	 damagedQty = parseInt(returnQty) - parseInt(goodQty);
	 $("#rejectedQty").val(damagedQty);
	 
	 var slvals = [];
	 $('input:checkbox[name=rejectedQty]:checked').each(function() {
	 slvals.push($(this).val());
	 
	 })
		 
	$("#rejectedSerialNumber").val(slvals);
	 
	 
	 $("#serialNumberDialog").fadeOut(300); 
 }
 function funSearchRequestId()
 {
     $("#productNameListDialog").fadeIn(300);  
    // $("#srchMinProductName").focus();
     $("#overlay").unbind("click");  
     $.ajax({
			dataType : 'html',
	        url : "${pageContext.request.contextPath}/getReceivingProductDetail.jsf",
	        type : "POST",
	        success : function(result) 
	        {
	  		   if(result != "")
	    	   {	
	  			  $("#listProjectNames").html(result); 
	  			//  $("#waitloadingProductName").hide();
	    	   }
	        }
	    });
 }
 
 function submitSerialNumber()
 {
	 hideSerialNumberDialog();
 }
 
 function hideProductNameListDialog()
 {
    $("#productNameListDialog").fadeOut(300);

 } 
 
 function funShowRequestNo(toolingRequestId,inspectionReportDate, originalId)
 {
	 $("#requestId").val(originalId);
	 $("#originalId").val(toolingRequestId);
	 $("#requestDate").val(inspectionReportDate);
	 hideProductNameListDialog();
	 funLoadInspectionDetails() ;
 }
 
 function changeAttr(value)
 {
	 $("#" + value).attr('checked', false);
 }
 
</script>

</head>
<body class="body" onload="Init();">
<form name="frmInspection" method="post"  id="frmInspection" autocomplete="off">
<%@ include file="tiimMenu.jsp"%>

<div id="loadoverlay" class="loading_overlay" ></div>
<img id="ajaxLoading" src="./images/ultraloading.jpg" class="loadingPosition"></img>
<div id="overlay" class="web_dialog_overlay" ></div>

    <div id="dialogRule" class="Vertical_web_dialog">
	  <table style="width:98%" align="center" cellpadding="2" cellspacing="0">
	    <tr><td></td></tr>	     
	    <tr>
	        <td>
			     <table style="width:99%" align="center" cellpadding="4" cellspacing="0" border="0">	     
				     <tr>
				        <td width="80%" align="left" class="popuptoptitlelarge">Quick Reference</td>			        			       
				        <td width="18%" align="right" class="popuptoptitle"><a title="Click to Close" class="popupanchor" id="ruleClose">X</a>&nbsp;</td>
				     </tr>
				     <tr>
				         <td colspan="2" height="5px"></td>
				     </tr>	
			    </table>
			     <table style="width:99%" align="center" class="tablesorter" cellpadding="4" cellspacing="0" border="0">		
			     	 <tr>
				     	 <td align="left" style="font-family: Verdana;font-size:10pt;color:#000000;"><img src="./images/Mouse-Pointer-icon.png"/></td>
				     	 <td align="left" style="font-family: Verdana;font-size:10pt;color:#000000;">Double click on particular row to edit values</td>
				     </tr>		     					     		     			
				     
				      <tr>
				     	 <td align="left"><img src="./images/right_arrow.png"/></td>
				     	 <td align="left" style="font-family: Verdana;font-size:10pt;color:#000000;">Press right arrow to move forward</td>
				     </tr>
				     <tr>
				     	 <td align="left"><img src="./images/left_arrow.png"/></td>
				     	 <td align="left" style="font-family: Verdana;font-size:10pt;color:#000000;">Press left arrow to move backward</td>
				     </tr>				    
				     <tr>
				     	 <td align="left"><img src="./images/up_arrow.png"/></td>
				     	 <td align="left" style="font-family: Verdana;font-size:10pt;color:#000000;">Press up arrow to move upward</td>
				     </tr>
				      <tr>
				     	 <td align="left"><img src="./images/down_arrow.png"/></td>
				     	 <td align="left" style="font-family: Verdana;font-size:10pt;color:#000000;">Press down arrow to move downward</td>
				     </tr>
				     <tr>
				     	 <td align="left"><img src="./images/enter_key.png"/></td>
				     	 <td align="left" style="font-family: Verdana;font-size:10pt;color:#000000;">Press enter key to move to next cell</td>
				     </tr>
				     <tr>
				     	 <td align="left" style="font-family: Verdana;font-size:10pt;color:#000000;">Home</td>
				     	 <td align="left" style="font-family: Verdana;font-size:10pt;color:#000000;">Press Home key to move to S.no</td>
				     </tr>
				     <tr>
				     	 <td align="left" style="font-family: Verdana;font-size:10pt;color:#000000;">End</td>
				     	 <td align="left" style="font-family: Verdana;font-size:10pt;color:#000000;">Press End key to move to Remarks</td>
				     </tr>			     			     			     			    			     		      	   			   			       
			     </table>	 
	        </td>
	      </tr>	       
	  </table>
	</div>
	
   <table class="spacerwht"  border="0" cellspacing="0" cellpadding="0"  align="center">
	  	<tr height="10px">
	         <td></td>
	    </tr>
   </table>
   <table width="100%" cellspacing="0" cellpadding="5" border="0" align="center"  height="25px">		      
       <tr>  
           <td width="35%" class="heading" align="left">&nbsp;New Tool Inspection Report</td> 
           <td width="45%" class="submenutitlesmall" align="center">
               <table cellspacing="1" cellpadding="2" width="57%" height="20px" align="left" style="display:none" id="msg">	
			     	<tr>  
				        <td class="confirmationmessage" align="center">&nbsp;&nbsp;&nbsp;<span id="dynmsg" style="align:center;">${msg}</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" class="msganchor" id="msgclose">X</a></td>
				    </tr>
			   </table>
           </td> 
           <td width="25%" class="submenutitlesmall" align="right">        
           		        
           </td>                                      
       </tr>
   </table>
    <div id="productNameListDialog" class="max_dialog">
	  <table style="width:98%" align="center" cellpadding="2" cellspacing="0" border="0">
	    <tr><td></td></tr>	     
	    <tr>
	        <td>
			   <table style="width:99%" align="center" cellpadding="4" cellspacing="0" border="0">	     
				     <tr>
				        <td width="18%" align="left" class="popuptoptitlelarge">Product Name</td>		
				         <td width="60%" align="center" class="popuptopalert"><span id="productNameAlert"></span></td>	        
				        <td width="10%" align="right" class="popuptoptitle"><a href="javascript:hideProductNameListDialog();" title="Click to Close" class="popupanchor">X</a>&nbsp;</td>
				     </tr>	 
				     <tr><td colspan="2"></td></tr>
				     <tr>
				        <td class="formlabelblack" align="center" colspan="2">
				             Search Drawing Number&nbsp;<span class="formlabel">*</span>&nbsp;&nbsp;&nbsp;<input  type="text" name="srchMinProductName" id="srchMinProductName" maxlength="150" value="" class="textmedium" />
	                         &nbsp;<input type="button" value="Go" class="btn btnSMImportant" onclick="funSearchMinProductName();"/>
	                    </td>		        			       	       
				     </tr>
				     <tr>
				         <td colspan="2" align="center">				           
					        <img id="waitloadingProductName" style="display:none;" src="./images/ultraloading.jpg" class="loadingPosition"></img>
					     </td></tr>
			   </table>   
	   		</td>
	   </tr>
	   </table>   
       <div id="listProjectNames" style="height:300px;overflow:auto;"></div>    
                                           
   </div>
    <div id="serialNumberDialog" class="max_dialog">
    <br>
    		<table style="width:99%" align="center" cellpadding="4" cellspacing="0" border="0">	     
				     <tr>
				        <td width="18%" align="left" class="popuptoptitlelarge">Received Serial Number</td>		
				         <td width="60%" align="center" class="popuptopalert"><span id="productNameAlert"></span></td>	        
				        <td width="10%" align="right" class="popuptoptitle"><a href="javascript:hideSerialNumberDialog();" title="Click to Close" class="popupanchor">X</a>&nbsp;</td>
				     </tr>	 
				     <tr><td colspan="2"></td></tr>
			 </table>
    	<div id="listSerialNumber" style="height:300px;overflow:auto;"></div>   
    	<table  border="0" cellspacing="0" cellpadding="0"  width="99%" align="center">
		    <tr>
	           <td height="50px" align="left">
			     <input type="button" class="btn btnNormal"  onclick="" value="Select All" />
			     <input type="button" class="btn btnNormal"  onclick="submitSerialNumber();" value="Submit" />
			     </td>
		    </tr>
		</table>       
    </div>
   <center>   
         <DIV STYLE="width: 99%; padding:0px; margin: 0px;height:auto;min-height:auto;" class="content">
         
         
             <!-- FIELDS -->
             <table class="spacerwht"  border="0" cellspacing="0" cellpadding="0"  align="center">
					<tr height="20px">
					<td></td>
					</tr>
				</table>
				<table style="width:70%" align="left" cellpadding="3" cellspacing="0" border="0">		
					<tr>
						<td width="10%" class="tabpopuplabel" align="left">&nbsp;</td>
						<td class="formlabelblack" align="left">Inspection Report No&nbsp;<span class="formlabel">*</span></td>
						<td class="formlabelblack" align="left">Inspection Report Date&nbsp;<span class="formlabel">*</span></td>			        	        			       	       
					</tr>
					<tr>
					    <td></td>
						<td class="popuplabel" align="left"><input  type="text" name="inspectionReportNo" id="inspectionReportNo" class="textmin" value="${inspectionReportNo}"  maxlength="7"  onkeypress="return funTypeReportNo(event,this);"autofocus autoComplete="off"/></td>
						<td class="popuplabel" align="left"><input id="inspectionReportDate" type="text" name="inspectionReportDate" class="textmin" value="${inspectionReportDate}"  maxlength="15" autoComplete="off" style="text-align:left;BORDER-RIGHT: black 1px groove; BORDER-TOP: black 1px groove; FONT-SIZE: 10pt;BORDER-LEFT: black 1px groove; BORDER-BOTTOM: black 1px groove; FONT-FAMILY: Tahoma;TEXT-DECORATION: none; background-color:#DDDDDD;" readonly/></td>
					</tr>		     			
					<tr>
						<td></td>
						<td width="10%" class="formlabelblack" align="left">Request Id&nbsp;<span class="formlabel">*</span>&nbsp;&nbsp;&nbsp;<span id="grnSatus" class="labelAlert">Invalid</span></td>						
						<td width="50%" class="formlabelblack" align="left">&nbsp;Request Date&nbsp;</td>												
					</tr>	
					<tr>
					    <td></td>
					    <td class="popuplabel" align="left">
					    	<c:choose>
					            <c:when test="${btnStatusVal eq 'Update'}">
				    				<input id="requestId" type="text" name="requestId" class="textmin" value="${requestId}" maxlength="5"  style="text-align:left;BORDER-RIGHT: black 1px groove; BORDER-TOP: black 1px groove; FONT-SIZE: 10pt;BORDER-LEFT: black 1px groove; BORDER-BOTTOM: black 1px groove; FONT-FAMILY: Tahoma;TEXT-DECORATION: none; background-color:#DDDDDD;" readonly  autoComplete="off"/>
				    			</c:when>
				    			<c:otherwise>
				    				<input id="requestId" type="text" name="requestId" class="textmin" value="${requestId}" maxlength="5"  onkeypress="return funTypeRequestNo(event,this);" autoComplete="off"/>
				    			</c:otherwise>
				    		</c:choose>	&nbsp;<input type="button" value="" onclick="javascript:funSearchRequestId();" class="btnselect"/>
				    	</td>
					    <td class="popuplabel" align="left"><input id="requestDate" type="text" name="requestDate" class="textmin" value="${requestDate}" autoComplete="off" style="text-align:left;BORDER-RIGHT: black 1px groove; BORDER-TOP: black 1px groove; FONT-SIZE: 10pt;BORDER-LEFT: black 1px groove; BORDER-BOTTOM: black 1px groove; FONT-FAMILY: Tahoma;TEXT-DECORATION: none; background-color:#DDDDDD;" readonly /></td>
					</tr>					     		    
					<tr>
					    <td class="popuplabel" colspan="3" align="center"><span id="autoStatus" class="popuptopalert"><br></span></td>
					</tr>
					<!-- <tr>
						<td></td>							
						<td class="popuplabel"  align="left"><input id="clear" type="button" name="clear" value="Clear All" class="btn btnSMNormal" onclick="javascript:funClear();"/></td>
						<td class="popuplabel"  align="left"></td>									        	        			       	      
					</tr>  -->					
					<tr>
						<td colspan="3"></td>
					</tr>	
				</table>
				<table class="spacerwht"  border="0" cellspacing="0" cellpadding="0" width="99%" align="center">
					<tr height="15px">
						<td><hr class="style-six"></td>
					</tr>
				</table>
             <!-- END -->
         
              <table cellspacing="0" width="99%" cellpadding="5" border="0" align="center" height="30px">		      
					<tr>  			 		           
						<td align="right" width="100%" class="labelanchor">
							
					    </td>
					</tr>
			  </table>    
			
				 <%
					int index = 1;
				 %>
				<c:choose>
					<c:when test="${fn:length(lstToolingProduct) gt 0}">
					<div class="table-responsive">
					        <table class="table table-bordered" style="max-width:98%;" align="center" id="receivingInspection">
					         <tr>
					              <th align="center" width="10%">S&nbsp;No.</th>
					              <!-- <th align="center" width="10%">Tooling&nbsp;No.</th> -->
					              <th align="center" width="10%">Product&nbsp;Name</th>
					              <th align="center" width="10%">Drawing&nbsp;No.</th>
					              <th align="center" width="10%">Max&nbsp;Comp. Force Limit</th>
					              <th align="center" width="10%">Machine&nbsp;Type</th>
					              <th align="center" width="10%">Type&nbsp;of&nbsp;Tooling</th>
								  <th align="center" width="10%">Lot&nbsp;Number&nbsp;</th>
								  <th align="center" width="10%">Punch&nbsp;Set&nbsp;No</th>
					              <th align="center" width="10%">Received&nbsp;Qty</th>
					              <th align="center" width="10%">UOM</th>
					              <th align="center" width="10%">Accepted Qty</th>
					              <th align="center" width="10%">Rejected Qty</th>
					              <!-- <th align="center" width="10%">Tool&nbsp;Serial&nbsp;No.</th> -->
					              <th align="center" width="10%">Inspection&nbsp;Status</th>
					              <th align="center" width="10%">Rejected&nbsp;SNo</th>                  
					              <th align="center" width="10%">Remark</th>        
					         </tr>
					         <c:choose>
					         <c:when test="${btnStatusVal eq 'Update'}">
					         		<c:forEach items="${lstToolingProduct}" var="lstToolingProduct" varStatus="row">  
						                 <tr id="rowid-<%=index%>">
									          <td align="center"><%=index%></td>
									          <td align="center">${lstToolingProduct.toolingname}</td>
									          <td align="center">${lstToolingProduct.drawingNo}</td>
									          <td align="center">${lstToolingProduct.compForce}</td>
									          <td align="center">${lstToolingProduct.machineType}</td>
											  <td align="center">${lstToolingProduct.typeOfTooling}</td>		  
											  <td align="center">${lstToolingProduct.lotNumber}<input type="hidden" id="lotNumber" name="lotNumber" value="${lstToolingProduct.lotNumber}"></td>
											  <td align="center">${lstToolingProduct.punchSetNo}</td>
											  <td align="center"><sapn id="receivedQuantity">${lstToolingProduct.receivedQuantity}</sapn> <input type="hidden" id="hidReceivedQty" name="hidReceivedQty" value="${lstToolingProduct.receivedQuantity}"/> </td>
											  <td align="center">${lstToolingProduct.uom}</td>
											  <td align="center"><input type="text" id="acceptedQty" name="acceptedQty" value="${lstToolingProduct.acceptedQty}"/></td>
											  <td align="center"><input type="text" id="rejectedQty" name="rejectedQty" value="${lstToolingProduct.rejectedQty}"/></td>
											  <%-- <td align="center"><input type="text" name="fldtoolSerialNo" id="toolSerialNo<%=index%>" class="txtleastavg"  value="" autocomplete="off"/></td> --%>
											  <td align="center">
											  		<select name="inspectionStatus" id="inspectionStatus<%=index%>">
											  		    <c:choose>
												  		    <c:when test="${lstToolingProduct.inspectionStatus1 eq 'Accepted'}">
												  				<option SELECTED>Accepted</option>
												  			</c:when>
												  			<c:otherwise>
												  				<option>Accepted</option>
												  			</c:otherwise>
											  			</c:choose>
											  			<c:choose>
											  				<c:when test="${lstToolingProduct.inspectionStatus1 eq 'Rejected'}">
												  				<option SELECTED>Rejected</option>
												  			</c:when>
												  			<c:otherwise>
												  				<option>Rejected</option>
												  			</c:otherwise>
												  		</c:choose>	
											  			<c:choose>
											  				<c:when test="${lstToolingProduct.inspectionStatus1 eq 'Hold'}">
												  				<option SELECTED>Hold</option>
												  			</c:when>
												  			<c:otherwise>
												  				<option>Hold</option>
												  			</c:otherwise>
												  		</c:choose>
											  		</select>
											  </td>
											 <td> <input type="text" name="rejectedSerialNumber" id="rejectedSerialNumber" class="textverysmall"  value="${lstToolingProduct.rejectedSerialNumber}" maxlenght="250"/></td>
											  <td align="center">
											  		<input type="text" name="remarks" id="remark<%=index%>" class="textverysmall"  value="${lstToolingProduct.remarks1}" maxlenght="250" autocomplete="off"/>
											        <input type="hidden" name="toolingInspectionDetailId" value="${lstToolingProduct.toolingInspectionDetailId1}"/>
											        <input type="hidden" name="toolingRequestDetailId" value="${lstToolingProduct.toolingRequestDetailId1}"/>
											  </td>
							           </tr> 
							           <%
							           index++;
							           %>
							           </c:forEach>
					         </c:when>
					         <c:otherwise>
					         		<c:forEach items="${lstToolingProduct}" var="lstToolingProduct" varStatus="row">  
						                 <tr id="rowid-<%=index%>">
									          <td align="center"><%=index%></td>
									          <td align="center">${lstToolingProduct.toolingname}</td>
									          <td align="center">${lstToolingProduct.drawingNo}</td>
									          <td align="center">${lstToolingProduct.compForce}</td>
									          <td align="center">${lstToolingProduct.machineType}</td>
											  <td align="center">${lstToolingProduct.typeOfTool}</td>				  		  
											  <td align="center">${lstToolingProduct.lotNumber}<input type="hidden" id="lotNumber" name="lotNumber" value="${lstToolingProduct.lotNumber}"/></td>
											  <td align="center">${lstToolingProduct.punchSetNo}</td>
											  <td align="center"><sapn id="receivedQuantity">${lstToolingProduct.receivedQuantity}</sapn><input type="hidden" id="hidReceivedQty" name="hidReceivedQty" value="${lstToolingProduct.receivedQuantity}"/></td>
											  <td align="center">${lstToolingProduct.uom}</td>
											  <td align="center"><input type="text" id="acceptedQty" name="acceptedQty" /></td>
											  <td align="center"><input type="text" id="rejectedQty" name="rejectedQty"/></td>
											  <%-- <td align="center"><input type="text" name="fldtoolSerialNo" id="toolSerialNo<%=index%>" class="txtleastavg"  value="" autocomplete="off"/></td> --%>
											  <td align="center">
											  		<select name="inspectionStatus" id="inspectionStatus<%=index%>">
											  			<option value='Accepted'>Accepted</option>
											  			<option value='Rejected'>Rejected</option>
											  			<option value='Hold'>Hold</option>
											  		</select>
											  	</td>
											  <td>	<input type="text" name="rejectedSerialNumber" id="rejectedSerialNumber" class="textverysmall"  maxlenght="250"/></td>
											  <td align="center">
											  		<input type="text" name="remarks" id="remark<%=index%>" class="textverysmall"  value="" maxlenght="250" autocomplete="off"/>
											        <input type="hidden" name="toolingRequestDetailId" value="${lstToolingProduct.toolingRequestDetailId1}"/>
											  </td>
							           </tr> 
							           <%
							           index++;
							           %>
							           </c:forEach>
					         </c:otherwise>
					         </c:choose>
					       </table> 
					       </div>	
				    </c:when>
				    <c:otherwise>
				    <div class="table-responsive">
					        <table class="table table-bordered"  style="max-width:98%;" align="center" id="cylinderFieldData1">
					         <tr>
					              <th align="center" width="10%">S&nbsp;No.</th>
					              <th align="center" width="10%">Product&nbsp;Name</th>
					              <th align="center" width="10%">Drawing&nbsp;No.</th>
					              <th align="center" width="10%">Max&nbsp;Comp. Force Limit</th>
					              <th align="center" width="10%">Machine&nbsp;Name</th>
					              <th align="center" width="10%">Type&nbsp;of&nbsp;Tooling</th>
								  <th align="center" width="10%">Lot&nbsp;Number&nbsp;</th>		
								  <th align="center" width="10%">Punch&nbsp;Set No</th>						  
					              <th align="center" width="10%">Received&nbsp;Qty</th>
					              <th align="center" width="10%">UOM</th>
					              <th align="center" width="10%">Accepted Qty</th>
					              <th align="center" width="10%">Rejected Qty</th>
					              <th align="center" width="10%">Inspection&nbsp;Status</th>     
					              <th align="center" width="10%">Rejected&nbsp;SNo</th>           
					              <th align="center" width="10%">Remark</th>        
					         </tr>
			                 <tr id="rowid-<%=index%>">
						          <td align="center">&nbsp;</td>
						          <!--<td align="center">&nbsp;</td> -->
						          <td align="center">&nbsp;</td>
						         <td align="center">&nbsp;</td>
								  <td align="center">&nbsp;</td>				  
								  <td align="center">&nbsp;</td>		
								  <td align="center">&nbsp;</td>			  
								  <td align="center">&nbsp;</td>
								  <td align="center">&nbsp;</td>
								  <td align="center">&nbsp;</td>
								  <td align="center">&nbsp;</td>
								  <!-- <td align="center">&nbsp;</td> -->
								  <td align="center">&nbsp;</td>
								  <td align="center">&nbsp;</td>
								  <td align="center">&nbsp;</td>
								  <td align="center">&nbsp;</td>
								  <td align="center">&nbsp;</td>
				           </tr> 		        		      
					       </table>  
					       </div>      
				    </c:otherwise>
				 </c:choose>
		       <input type="hidden" name="originalId" id="originalId" value="0"/>
		       <input type="hidden" name="count" id="count" value="${count}" />
		       <input type="hidden" name="gridOrgCount" id="gridOrgCount" value="${gridOrgCount}" />
		       <input type="hidden" name="message" id="message" value="${msg}" />
		       <input type="hidden" name="serilaFlag" id="serilaFlag" value="${serilaFlag}" />
		       <input type="hidden" name="toolingInspectionId" id="toolingInspectionId" value="${toolingInspectionId}" />
		       <table cellspacing="0" width="98%" cellpadding="5" border="0" align="center">		
		            <tr><td></td></tr>      
					<tr>  
						<td align="right" class="legend" width="99%"><!-- <img border="0"  src="./images/rules.png">&nbsp;-&nbsp;Quick Reference&nbsp; -->&nbsp;</td> 		            				
					</tr>
			 </table>       
			 <table  border="0" cellspacing="0" cellpadding="0"  align="center">
			    <tr height="10px">
		           <td height="10px" align="center">&nbsp;</td>
			   </tr>
	        </table> 
	       
     </DIV>
     </center>    
     
     <table  border="0" cellspacing="0" cellpadding="0"  width="99%" align="center">
	    <tr>
           <td height="50px" align="left">
		     <input  type="button" class="${btnSatusStyle}" id="btnProcess" value="${btnStatusVal}" onclick="javascript:processInspection('${btnStatusVal}');" ${btnStatus} />&nbsp;&nbsp;
		     <input type="button" class="btn btnNormal"  onclick="javascript:funToolingList();" value="List" />
		     <c:if test="${serilaFlag == 1}">
		  	   <input type="button" class="btn btnNormal"  onclick="getSerialNumber();" value="Serial" />
		     </c:if>
		     </td>
	    </tr>
	 </table>       
     <table  border="0" cellspacing="0" cellpadding="0"  align="center">
		    <tr height="30px">
	           <td height="50px" align="center">&nbsp;</td>
		   </tr>
	 </table>
	 
	        
</form>
</body>
</html>