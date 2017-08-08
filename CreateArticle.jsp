<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import ="teamhalp.dao.*, java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
     <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="A Bootstrap Blog Template">
	<meta name="author" content="Vijaya Anand">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    
     <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Black+Ops+One" />
    <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Rock+Salt" />
     
    <!-- Bootstrap -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    
    
    <!-- Jquery (For datechecker) -->
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  	
  	<!-- JQuery Text editor -->
  	<link type="text/css" rel="stylesheet" href="assets/jquery-te-1.4.0.css">
	<script type="text/javascript" src="assets/jquery-te-1.4.0.js" charset="utf-8"></script>
  	
  	 	
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">		
   
    
      <!-- Bootstrap Core CSS -->
    <link href="bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="blog-post.css" rel="stylesheet">

 	 <script>		
 		 $( function() {		
    	$( "#datepicker").datepicker();		
  		} );		
     </script>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    
    <title>HALPHomePage</title>
    
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


        	

<div class="jumbotron text-center">
		<h1 style="font-family:  Black Ops One; font-size: 90px; font-style: normal; font-variant: normal; font-weight: 500; color:wheat" ><i>H  A  L  P  f  u  l</i></h1>
		<p style="font-family: Rock Salt; font-size: 40px; color: whitesmoke">B l o g s</p>
</div>



	


    <!-- Page Content -->
    <div class="container">

        <div class="row">

            <!-- Blog Post Content Column -->
            <div class="col-lg-8">

                <!-- Blog Post creation form -->
				<form id="createArticleForm" method="POST" action="ArticleCreation">
                
                <!-- Title -->
                <input name = "title" type="text" required size=102 placeholder="Enter a title for your post"><h1></h1>
				<hr>

                <!-- Post Content -->
                <textarea name="content" class="jqte-test" placeholder="Please type your post content here"></textarea>
                <hr>
                
            </div>

            <!-- Date picker calendar -->
            <div class="col-md-4">
				<div class="well">
               <!-- class="col-lg-3 control-label" -->
               <label>&#160;&#160;&#160; <i>Please choose a date for your post</i></span></label> 
                 <div class="input-group">
          			 <div class="col-lg-8">
          			<div id="datepicker" name="articleDate"></div>
         			 </div>
       			 </div>
       			 </div>

				<%-- form Submit button --%>
                <div class="panel panel-default">
					<div class="panel-heading">
					<button type="submit" class="button">Submit</button></a>
					</div>
				</div>
				
				</form>
                

            </div>

        </div>
        <!-- /.row -->

        <hr>

        <!-- Footer -->
        <footer>
            <div class="row">
                <div class="col-lg-12">
                    <p>Copyright &copy; HALP Blogging Website 2020</p>
                </div>
            </div>
            <!-- /.row -->
        </footer>

    </div>
    <!-- /.container -->


	<%-- Date Picker and TextEditor script --%>
	<script>
 	// initialise the datepicker
 	$( function() {
    	$( "#datepicker" ).datepicker({
    	});  	
    });
 	// add onchange listener on the datepicker
 	var myNewAction = "ArticleCreation";		
	$(document).on("change", "#datepicker", function () {		
		myNewAction = "ArticleCreation" +"?articleDate=" + $(this).val();		
		document.getElementById("createArticleForm").setAttribute("action", myNewAction);		
    })
    
    //JQUERY TEXT EDITOR feature
    $('.jqte-test').jqte();
      
    </script>
  

    <!-- jQuery -->
    <script src="js/jquery.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>
	<script src="lib/jquery-2.0.3.min.js"></script>
	<script src="lib/bootstrap-3.0.3/js/bootstrap.min.js"></script>

</body>
</html>