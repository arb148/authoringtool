<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<%
	String pageType = "";
	if (request.getParameter("type") != null) {
		pageType = request.getParameter("type");
	}
	if (!pageType.equalsIgnoreCase("myquizzes") && !pageType.equalsIgnoreCase("modify")) {
		pageType = "myquizzes";
	}
%>
<script src="<%=request.getContextPath()%>/js/jquery1.4.2.js"></script>

<script type="text/javascript">
$(document).ready(function() {
	$("img").click(function () {
		var fn = $(this).attr('fn');
		if (fn == 'deleteQuiz') {
			var qid = $(this).attr('qid');
			if (confirm('Are you sure you want to delete this quiz?')==true) {
				$.post("DeleteQuizServlet?QuestionID="+qid,function(data) {
					var err = data.message;
					if (err != '')
					{
						alert(err);
					} else {
						alert("Quiz deleted successfully!");window.location.reload(true)
					}
				},"json");	 
			}			
		}
	});	
});	
</script>

<script language="javascript">
	function send_iswriting(e) {
	     var key = -1 ;
	     var shift ;
	
	     key = e.keyCode ;
	     shift = e.shiftKey ;
	
	     if ( !shift && ( key == 13 ) ) {
	          document.form.reset() ;
	     }
	}
</script>
<script language="javascript">
	function changelist() {
		var quid=document.jquizmodify.question.value;
		document.location.href="jquestion_modify1.jsp?msg=0&QuestionID="+quid;  
	}                                                                                
</script>

<h3><% if (pageType.equalsIgnoreCase("modify")) { out.print("Modify Java Topic:"); }  else { out.print("My Topics:"); }%></h3>

<form role="form" name="JQuestionModify" method="post" action="jquestion_modify_save.jsp">
	<ul class="list-group">

<%	 
	Statement statement = conn.createStatement();
	String uid="";
	ResultSet rs = null;  
	rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	while(rs.next()) {
	 	uid=rs.getString(1);  	
	} 
 	 
	ResultSet rs1 = null;
	if (pageType.equalsIgnoreCase("modify")) {
		rs1 = statement.executeQuery("SELECT distinct q.QuestionID, q.Title, q.Description, q.Privacy,q.AuthorID from ent_jquestion q, ent_user u where q.AuthorID=u.id and (q.Privacy='1' or u.name='"+userBeanName+"') order by q.title");
	} else {
		rs1 = statement.executeQuery("SELECT distinct q.QuestionID, q.Title, q.Description, q.Privacy,q.AuthorID from ent_jquestion q, ent_user u where q.AuthorID=u.id and u.name='"+userBeanName+"' order by q.title");	
	}
	int cnt=0;
	String mobileView = "";
	while(rs1.next()) {
		cnt++;
		mobileView = (cnt > 1) ? " hidden-md hidden-lg": "";
		out.write("<input type=hidden name='jquestionid"+cnt+"' value='"+rs1.getString(1)+"'>");
%>
		<li class="list-group-item">
	  	<div class="form-inline">
	  		<div class="form-group">
	  			<p class="help-block<%= mobileView %>">Title:</p>
<%
                out.write("<textarea class=\"form-control\" rows=\"2\" name=\"Title"+cnt+"\" value=\""+rs1.getString(2)+"\" cols=\"60\">"+rs1.getString(2)+"</textarea>");
%>
            </div>
            <div class="form-group">
            	<p class="help-block<%= mobileView %>">Description:</p>
<%
                String curValue = rs1.getString(3);
				curValue = (curValue == null) ? "" : curValue;
				out.write("<textarea class=\"form-control\" rows=\"2\" name=\"Description"+cnt+"\" value=\""+curValue+"\"  cols=\"60\">"+curValue+"</textarea>");
%>
            </div>
            <div class="form-group">
<%	 
		String radioPrivate = "";
		String radioPublic = "";
		String radioDisabled = "";
		if (rs1.getString(4).equals("1")) {	
			radioPublic = "checked";
			if (!rs1.getString(5).equals(uid)) {
				radioDisabled = "disabled";		 			 		  	 	 	
			}
		}else{
			radioPrivate = "checked";
		}
%>
			<label class="radio-inline">
				<input type="radio" name="privacy<%= cnt %>" value="private" <%= radioPrivate+" "+radioDisabled %>>Private
			</label>
			<label class="radio-inline">
				<input type="radio" name="privacy<%= cnt %>" value="public" <%= radioPublic %>>Public
			</label>
           </div>
	    </div>
	  </li>
<%  		 
	}	  	 	 
	out.write("<input type=hidden name=cnt value='"+cnt+"'>");
%>	
		<input type="submit" value="Save" class="btn btn-default" style="margin-top: 10px;">
	</ul>
</form>

</body> 
</html>

<%@ include file = "include/htmlbottom.jsp" %>