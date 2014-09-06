<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>

<script language="javascript">
	function send_iswriting(e){
	     var key = -1 ;
	     var shift ;
	     key = e.keyCode ;
	     shift = e.shiftKey ;
	
	     if ( !shift && ( key == 13 ) )
	     {
	          document.form.reset() ;
	     }
	}
</script>
<script src="<%=request.getContextPath()%>/js/jquery1.4.2.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$("input").click(function () {
			var fn = $(this).attr('fn');
			if (fn == 'create') {
				var topic = document.getElementById("topic").value;
				var title = document.create_example.title.value;
				title = title.replace(/\s+/g, '');
				var rdfID = document.create_example.rdfID.value;
				rdfID = rdfID.replace(/\s+/g, '');
				var privacy = document.create_example.privacy;
				var selected = false;
				var code =  document.create_example.textarea1.value;
				var tempCode = code.replace(/\s+/g, '');
				for(var i = 0; i < privacy.length; i++) {
					if(privacy[i].checked == true) {
						selected = true;
					}
				}
				if (topic== "-1") {
					alertMessage('Please select topic for the example.');
					return false;
				}
				if (title == "") {
					alertMessage('Title cannot be empty!');
					return false;
				} else if (rdfID == "") {
					alertMessage("RDF ID cannot be empty!");
					return false;
				} else if (selected == false) {
					alertMessage("Please select the privacy.");
					return false;
				} else if (code == '' | tempCode =='' ) {
					alertMessage("Code cannot be empty!");
					return false;
				} else {
					var invalid = false;
					rdfID = document.create_example.rdfID.value;
					for (var index in rdfs) {
						if (rdfs[index] == rdfID)
							invalid = true;
					}
	    			if (invalid) {
	    				alertMessage("RDF ID already exists. Please enter another value.");
	    				return false;
	    			} else {   				 
						$("#eform").submit();
					}
	    		}
			}		
		});	
	});	
	
	function alertMessage (text) {
		$("#alertMessage").hide().html('<div class="alert alert-danger alert-dismissible" role="alert">'+
				'<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>'+
				text+'</div>').fadeIn('slow');
		$("html, body").animate({ scrollTop: 0 }, "slow");
	}
	
	function clearForm() {
		$("html, body").animate({ scrollTop: 0 }, "slow");
		document.form.message.focus();
	}
</script>

<%
	stmt = conn.createStatement();
	String command = "select rdfID from ent_dissection;";
	ResultSet rs = stmt.executeQuery(command);
	ArrayList<String> rdfList = new ArrayList<String>();
	while (rs.next()) {
		rdfList.add(rs.getString(1));
	}
%>

<script>
    var uname = "<%=userBeanName%>";
	var rdfs = new Array();
	<%for (String rdf : rdfList){%>
	     rdfs.push("<%=rdf%>");
	<%}%>
</script>

<%
	String uid = "";
	rs = stmt.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	while(rs.next()) {
		 uid = rs.getString(1);
	}
	command = "select * from ent_scope s, rel_scope_privacy sp where sp.ScopeID = s.ScopeID and (sp.privacy = 1 or sp.Uid = "+uid+")";
	result1 = stmt.executeQuery(command);
%>

<h3>Create example:</h3>
<hr>
<form class="form-horizontal" role="form" id = "eform" name = "create_example" method="post" action="createExampleComment.jsp">
	<div id="alertMessage"></div>
	<div class="form-group">
    	<label for="topic" class="col-sm-3 control-label">Topic:<span style="color: red;"> *</span></label>
	    <div class="col-sm-9">
	    	<select name="topic" id="topic" class="form-control">
<%
				out.write("<option value='-1' selected>Please select the topic</option>");
				
				rs = stmt.executeQuery("SELECT q.QuestionID,q.Title,q.Privacy,q.authorid FROM ent_jquestion q where (q.Privacy = '1' or q.authorid = "+uid+") order by q.title");
				String imgHtml;
				while(rs.next()) {
					imgHtml = (rs.getString(4).equals(uid)) ? "style=\"background-color:#A9A9D5\" title = \"You are the owner of this quiz\"": "";
					out.write("<option value='"+rs.getString(1)+"'"+imgHtml+">"+rs.getString(2)+"</option>");
				}				
%>	
	    	</select>
	    </div>
	</div>
	<div class="form-group">
	    <label for="title" class="col-sm-3 control-label">Title:<span style="color: red;"> *</span></label>
	    <div class="col-sm-9">
	    	<input type="text" name="title" maxlength="45" class="form-control" />
	    </div>
	</div>
	<div class="form-group">
	    <label for="rdfID" class="col-sm-3 control-label">RDF ID:<span style="color: red;"> *</span></label>
	    <div class="col-sm-9">
	    	<input type="text" name="rdfID" class="form-control">
	    </div>
	</div>
	<div class="form-group">
	    <label for="chapter" class="col-sm-3 control-label">Description:</label>
	    <div class="col-sm-9">
			<textarea  name="chapter" cols="70" rows="3" class="form-control"></textarea>
	    </div>
	</div>
	<div class="form-group">
    	<label for="privacy" class="col-sm-3 control-label">Privacy:<span style="color: red;"> *</span></label>
	    <div class="col-sm-9">
	    	<label class="radio-inline">
				<input type="radio" name="privacy" value="Private">Private
			</label>
			<label class="radio-inline">
				<input type="radio" name="privacy" value="Public">Public
			</label>
	    </div>
	</div>
	<div class="form-group">
	    <label for="textarea1" class="col-sm-3 control-label">Code:<span style="color: red;"> *</span></label>
	    <div class="col-sm-9">
			<textarea name="textarea1"  id="code" cols="75" rows="15" class="form-control"></textarea>
	    </div>
	</div>
	<div class="form-group">
	    <div class="col-sm-offset-3 col-sm-9">
	    	<input Type= "button" value="Create" fn='create' class="btn btn-default">
	    	<input type="reset" value="Clear" onclick="clearForm();" class="btn btn-default">
	    	<a href="authoring.jsp?type=example" class="btn btn-default pull-right">Cancel</a>
	    </div>
	</div>
</form>

<%@ include file = "include/htmlbottom.jsp" %>