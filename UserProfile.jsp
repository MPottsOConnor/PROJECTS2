<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ page import ="teamhalp.dao.*, java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%!String author; 
	String uname;
    String ufname;
    String ulname;
	String upassword;
	String uemail;
	String ueducation;
	Date date;
	String ucountry;%>
	<%-- These two lines cannot be merged with above declaration block - tested many times --%>
	<%String realIconPath = getServletContext().getRealPath("/Icons/");
	String iconPath = realIconPath.substring(realIconPath.indexOf("TeamHalp")-1);%>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="A Bootstrap Blog Template">
	<meta name="author" content="Vijaya Anand">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- below are replica bootstraps, please remove on each page in favour of local file -->
    <link rel="stylesheet" href="assets/bootstrap.css">
    <link rel="stylesheet" href="assets/bootstrap-select.css">
    
    
     <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Black+Ops+One" />
    <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Rock+Salt" />
     
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  	<link rel="stylesheet" href="/resources/demos/style.css">
  	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  	<script src="https://thdoan.github.io/bootstrap-select/js/bootstrap-select.js"></script>
 <script>
 $( function() {
	    $( "#datepicker" ).datepicker({minDate: "-100Y", maxDate: "-2M", yearRange: "-100:+nn",
	      changeMonth: true,
	      changeYear: true
	    });
	  });
   </script>
    
    <title>HALP Blogs HomePage - Edit your profile</title>
    
    <style>
    <%@include file="assets/homepage.css"%>
    </style>

</head>
<body>
<!-- Navigation bar - 
	 First check if a user is not logged on to redirect them to homepage; else display the (user logged on) Nav bar -->
<%if(session.getAttribute("Logged on user")==null){
	response.sendRedirect("Homepage.jsp"); 
	return;
} else{%>
	<jsp:include page="WEB-INF/NavBar2.jsp" />
<%}%>


<%
User user = (User)(session.getAttribute("Logged on user"));
ufname = user.getFName() != null ? user.getFName() : "" ;
ulname = user.getLName() != null ? user.getLName() : "" ;
uname = user.getUName();
uemail = user.getEmail() != null ? user.getEmail() : "" ;
upassword = user.getPw();
ueducation = user.getEducation() != null ? user.getEducation() : "" ;
ucountry = user.getCountry() != null ? user.getCountry() : "" ;
date = user.getDoB();%>  


<div class="jumbotron text-center">
		<h1 style="font-family:  Black Ops One; font-size: 90px; font-style: normal; font-variant: normal; font-weight: 500; color:wheat" ><i>H  A  L  P  f  u  l</i></h1>
		<p style="font-family: Rock Salt; font-size: 40px; color: whitesmoke">B l o g s</p>
</div>

	<!-- Body -->
<div class="container" style="padding-top: 60px;">
  <h1 class="page-header">Edit Profile</h1>
  <div class="row">
    <!-- left column -->
    <div class="col-md-4 col-sm-6 col-xs-12">
      <div class="text-center">
        <% 
        String srcString = "http://placehold.it/200x200";
        
        if (user.getIcon()!= null) {
        java.io.File f = new java.io.File(realIconPath+user.getIcon());
        
        srcString = (f.exists() && f.canRead()) ? iconPath+user.getIcon() : "http://placehold.it/200x200";
        } 
        
        String currentIcon = user.getIcon() != null ? user.getIcon() : "";
        String default1Selected = (currentIcon.equals("default-1.png") ? "selected" : "");
        String default2Selected = (currentIcon.equals("default-2.png") ? "selected" : "");
        String default3Selected = (currentIcon.equals("default-3.png") ? "selected" : "");
        String default4Selected = (currentIcon.equals("default-4.png") ? "selected" : "");%>
        
        <img src=<%=srcString %> class="avatar img-circle img-thumbnail" alt="Pls upload an icon">
        
        <div>
        <form action="IconUpload?icon_selection=true" method="post" class="form-inline">
			        <input hidden name="icon_selection" />
			        <select title="Select your surfboard" class="selectpicker" name="selection" >
					  <option value="default-1" <%=default1Selected%> data-thumbnail="defaulticon/default-1.png">Default Icon-1</option>
					  <option value="default-2" <%=default2Selected%> data-thumbnail="defaulticon/default-2.png">Default Icon-2</option>
					  <option value="default-3" <%=default3Selected%> data-thumbnail="defaulticon/default-3.png">Default Icon-3</option>
					  <option value="default-4" <%=default4Selected%> data-thumbnail="defaulticon/default-4.png">Default Icon-4</option>
					</select>
					<input type="submit" class="btn btn-primary" value="Select Icon" />
					</form>
        
        
        <h6>Upload a different photo...</h6>
        <form action="IconUpload?iconupload=true" method="post" enctype="multipart/form-data" class="form-inline">
        <input hidden name="iconupload" />
        <div class="row">
        <input id="uploadFileBox" type="file" name="file" class="text-center col-xs-9" required>
        <!--  center-block-->

        <input type="submit" class="btn btn-primary col-xs-3" value="Upload File" />
        </div>
		</form>
		</div>
			
			<br />
			
      </div>
    </div>
    <!-- edit form column -->
    <div class="col-md-8 col-sm-6 col-xs-12 personal-info">
    <!--   <div class="alert alert-info alert-dismissable">
       <a class="panel-close close" data-dismiss="alert">×</a>
        <i class="fa fa-coffee"></i>
        This is an <strong>.alert</strong>. Use this to show important messages to the user.
      </div> -->
      <h3>Personal info</h3>
      <form class="form-horizontal" role="form" id='userprof_id' method='post' action='UserHome?userupdate=true'>
        <input hidden name="userupdate" />
        <div class="form-group">
          <label class="col-lg-3 control-label">First name:</label>
          <div class="col-lg-8">
            <input class="form-control" type="text" name='firstname' value='<%=ufname%>' pattern="^(?!drop table).*$">
          </div>
        </div>
        <div class="form-group">
          <label class="col-lg-3 control-label">Last name:</label>
          <div class="col-lg-8">
            <input class="form-control" name='lastname' value='<%=ulname %>' pattern="^(?!drop table).*$" type="text">
          </div>
        </div>
        <div class="form-group">
          <label class="col-md-3 control-label">Username:</label>
          <div class="col-md-8">
            <input disabled class="form-control" name='username' value='<%=uname%>' type="text">
          </div>
        </div>
        <div class="form-group">
          <label class="col-lg-3 control-label">Change password:</label>
          <div class="col-lg-8">
            <input class="form-control" name='password' value="<%=upassword%>" pattern="^(?!drop table).*$" type="password" required='required'>
          </div>
        </div>
        <div class="form-group">
          <label class="col-lg-3 control-label">Education:</label>
          <div class="col-lg-8">
            <input class="form-control" name='education' pattern="[a-zA-Z\\- ']*" value='<%=ueducation%>' type="text">
          </div>
        </div>
        <div class="form-group">
          <label class="col-lg-3 control-label">Country:</label>
          <div class="col-lg-8">
          <input class="form-control" name='country' pattern="[a-zA-Z\\- ']*" value='<%=ucountry %>' pattern="^(?!drop table).*$" type="text">
          </div>
        </div>
        <div class="form-group">
          <label class="col-lg-3 control-label">Email:</label>
          <div class="col-lg-8">
            <input class="form-control" name='useremail' value='<%=uemail %>' type="text">
          </div>
        </div>
        <div class="form-group">
          <label class="col-lg-3 control-label">Date of birth:</label>
          <div class="col-lg-8">
          <input class="form-control" type="text" id="datepicker" name="date" value='<%=(date!=null? date : "")%>'>
          </div>
        </div>
        <div class="form-group">
          <label class="col-md-3 control-label"></label>
          <div class="col-md-8">
           
             <span></span>
            <input id="saveChanges" class="btn btn-primary" value="Save Changes" type="submit">
           
           
               
      	</form>
     	 <form id="delete" action="UserHome?userdeletion=true" method="post" onsubmit="return show_alert();">
            <input hidden name="userdeletion" />        
            <input class="btn btn-default" type="submit" id="delete" value="Delete Account"/>
    	   </form>
  </div>
        </div>
    </div>
  </div>
</div>
<hr>

	<!-- Footer 
	<footer>
		<div class="container">
			<hr />
			<p class="text-center">Copyright &copy; Astrospace 2014. All rights reserved.</p>
		</div>
	</footer>-->

	<!-- Jquery and Bootstrap Script files -->
	<script src="lib/jquery-2.0.3.min.js"></script>
	<script src="lib/bootstrap-3.0.3/js/bootstrap.min.js"></script>
	<script>
	function show_alert() {
		  if(confirm("Do you really want to do this?")){
		  	return true;
		  } else{
		    return false;
		  }
	}
	</script>



</body>
</html>