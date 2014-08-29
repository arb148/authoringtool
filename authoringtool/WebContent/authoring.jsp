<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

<%
	String selected = "";
	if (request.getParameter("type") != null) {
		selected = request.getParameter("type");
	}
	if (!selected.equalsIgnoreCase("quiz") && !selected.equalsIgnoreCase("example")) {
		selected = "topic";
	}
	
	if (request.getParameter("message") != null && request.getParameter("alert") != null) {
		String message = request.getParameter("message");
		String alertType = request.getParameter("alert");
		%>
			<div class="alert alert-<%= alertType %> alert-dismissible" role="alert">
				<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<%= message %>
			</div>
		<%		
	}
%>
	
	<div class="panel-group" id="accordion">
	  <div class="panel panel-default">
	    <div class="panel-heading">
	      <h4 class="panel-title">
	        <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
	          Topic Authoring
	        </a>
	      </h4>
	    </div>
	    <div id="collapseOne" class="panel-collapse collapse<% if (selected.equalsIgnoreCase("topic")) { out.print(" in"); } %>">
	      <div class="panel-body">
	      	<ul>
				<li><a href="jquiz_create.jsp">Create</a></li>	
				<li><a href="myQuizzes.jsp?type=modify">Modify</a></li>
			</ul> 
			<img src=images/owner.gif>&nbsp;&nbsp;<a href="myQuizzes.jsp?type=myquizzes">My Topics</a>
	      </div>
	    </div>
	  </div>
	  <div class="panel panel-default">
	    <div class="panel-heading">
	      <h4 class="panel-title">
	        <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
	          Quizjet Authoring
	        </a>
	      </h4>
	    </div>
	    <div id="collapseTwo" class="panel-collapse collapse <% if (selected.equalsIgnoreCase("quiz")) { out.print(" in"); } %>">
	      <div class="panel-body">
	      	<ul>
				<li><a href="jquestion_create.jsp">Create</a></li>	
				<li><a href="jquestion_modify.jsp">Modify</a></li>
				<li><a href="jquestion_concept.jsp">Index</a></li>					
			</ul>
			<img src=images/owner.gif>&nbsp;&nbsp;<a href="myQuestions.jsp">My questions</a>
	      </div>
	    </div>
	  </div>
	  <div class="panel panel-default">
	    <div class="panel-heading">
	      <h4 class="panel-title">
	        <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">
	          Example Authoring
	        </a>
	      </h4>
	    </div>
	    <div id="collapseThree" class="panel-collapse collapse <% if (selected.equalsIgnoreCase("example")) { out.print(" in"); } %>">
	      <div class="panel-body">
	      	<ul>
				<li><a href="create_example.jsp">Create</a></li>	
				<li><a href="displayA1.jsp">Modify</a></li>  
				<li><a href="concept_indexing1.jsp?sc=12&ex=-1">Index</a></li> 
			</ul>
			<img src=images/owner.gif>&nbsp;&nbsp;<a href="mine.jsp">My Examples</a>
	      </div>
	    </div>
	  </div>
	</div>


        <!-- 
            <td class="tabhead" width="1"><nobr><a href="ScopeAuthoring.jsp" STYLE="text-decoration:none">Scope Authoring</a></nobr></td>                                 
        
        @roya : These lines are commented for the current release, may be added based on future needs
          <td class="tabhead" width="1"><nobr><a href="conceptAuthoring.jsp" STYLE="text-decoration:none">Concept Authoring</a></nobr></td>
          <td class="tabhead" width="1"><nobr><a href="crawl.jsp" STYLE="text-decoration:none">Crawl Example</a></nobr></td>
          -->
<%@ include file = "include/htmlbottom.jsp" %>