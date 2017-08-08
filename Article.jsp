<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import ="teamhalp.dao.*, java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="A Bootstrap Blog Template">
	<meta name="author" content="Vijaya Anand">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    
    <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Black+Ops+One" />
    <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Rock+Salt" />
       
       <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <!-- <link href="assets/blog-post.css" rel="stylesheet"> -->
   

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    
    <!-- Text editor -->
  	<link type="text/css" rel="stylesheet" href="assets/jquery-te-1.4.0.css">
	<script type="text/javascript" src="assets/jquery-te-1.4.0.js" charset="utf-8"></script>
  	
    
    <!-- javascript functions for setting up the delegation of the editComment feature 
    	 (its simpler than it looks, most of it is simple DOM manipulation) -->
    <script src="assets/EditDeleteFunctions.js"></script>
    
    <title>HALP HomePage</title>
    
    <style>
    	<%@include file="assets/homepage.css"%>
    	
    </style>

</head>

<body>

<%-- First check if article parameter exists so we know which article to display, 
		if it doesn't then redirect to homepage --%>
<% if (request.getParameter("article")==null) {response.sendRedirect("Homepage.jsp"); return;}%>
	
	
<!-- Navigation bar -->
<%if(session.getAttribute("Logged on user")==null){%>
	<jsp:include page="WEB-INF/NavBar1.jsp" />
<%} else{%>
	<jsp:include page="WEB-INF/NavBar2.jsp" />
<%}%>


<div class="jumbotron text-center">
		<h1 style="font-family:  Black Ops One; font-size: 90px; font-style: normal; font-variant: normal; font-weight: 500; color:wheat" ><i>H  A  L  P  f  u  l</i></h1>
		<p style="font-family: Rock Salt; font-size: 40px; color: whitesmoke">B l o g s</p>
	</div> 
</div>
	
	<%-- Now grab the article parameter to display the chosen article, and also get the article's comments --%>
	<%int id = Integer.parseInt(request.getParameter("article"));
	ArticleDAO articleDAO = new ArticleDAO();
	Article article = articleDAO.getById(id);
	
	CommentDAO commentDAO = new CommentDAO();
	List<Comment> comments = commentDAO.getByArticle_id(id);
	%>


    <!-- Page Content -->
    <div class="container">
		<div class="row">
			<!-- Blog Post Content Column -->
            <div class="col-lg-8">

                <!-- Blog article Post -->

                <!-- Title -->
                <span id="articleNo" name="<%=id%>"></span>
                <h1><%=article.getTitle()%></h1>

                <!-- Author -->
                <p class="lead">
                By <%=article.getCreated_by()%>
                </p><hr>

                <!-- Date/Time -->
                <div><span class="glyphicon glyphicon-time"></span> Posted on <%=article.getCreated_at() %>
                
                <%-- Display Edit and Delete buttons for Article only if the logged on user created the article --%>
                <% if (session.getAttribute("Logged on user")!= null 
                		&& session.getAttribute("Username").toString().equals(article.getCreated_by())){ %>
                        	<span id="articleButtons"><span id="editButtonLocation">
                        	
                        	<button style="float:right" type="button" onclick="deleteArticle()" class="btn btn-primary" id="deleteArticle">Delete</button>
                        	
                        	<button type="button" onclick="editArticle()" class="btn btn-primary" id="editArticle">Edit</button></span>
                        	
                       		</span>
                <%}%>
                
                </div><hr>

                
                
                <!-- Post Content -->
                <span id="contentWrapper"><div class="lead" id="articleContentArea"><%=article.getContent()%></div></span>
                <div id="insertDoneButtonHere"></div><br><br><hr>



                <!-- Comments Form - only show if a user is logged on -->
                <%if (session.getAttribute("Logged on user")!= null){ %>
                <div class="well">
                    <h4>Leave a Comment:</h4>
                    <form role="form" action="<%session.setAttribute("articleid", article.getArticle_id());%>CommentSubmit" method="post">
                        <div class="form-group">
                            <textarea name="content" class="form-control" rows="3"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </form>
                </div>
               <%}%>

                <hr>

                
                <!-- Display all posted Comments -->
                <a name="comments"></a> <!--  Comments anchor -->
              <%if (comments!=null){  
           	   for(int i = comments.size()-1; i>=0; i--) {
                Comment comment = comments.get(i);
                String commentContent = comment.getContent();
                int comment_id= comment.getComment_id();
                String authorString = comment.getCreated_by();
                User commentAuthor = new UserDAO().getByUName(authorString);
                
                // This block of code is for displaying user icons with comments, looks nice
                String realIconPath = getServletContext().getRealPath("/Icons/");
				String iconPath = realIconPath.substring(realIconPath.indexOf("TeamHalp")-1);
                String srcString = "http://placehold.it/18x18";
				if (commentAuthor.getIcon()!= null) {
			    	java.io.File f = new java.io.File(realIconPath+commentAuthor.getIcon());
					if (f.exists() && f.canRead()) {
				    	String commentIcon = commentAuthor.getIcon();
				       	String thumbnail = iconPath + "thumbnail-" +commentIcon.substring(commentIcon.indexOf("-")+1, commentIcon.indexOf(".")) + ".png";
				       	srcString = thumbnail;
					}
				}%>
                <div class="media" id="comment<%=comment_id%>">
                    <a class="pull-left" href="UserHome.jsp?author=<%=authorString%>" name="comment<%=comment_id%>">
                        <img class="media-object" src="<%=srcString%>" alt=""/></a>
                    <div class="media-body">
                        <h4 class="media-heading"><a href="UserHome.jsp?author=<%=authorString%>"><%=authorString%></a>
                            <small><%=comment.getCreated_at()%></small></h4>
                        <p class="comment" id="<%=comment_id%>"><%=comment.getContent()%></p>
                    </div>
                        
                        <%-- For each comment, decide whether to show Edit and Delete links/buttons 
                        	 First, check if a user is logged on--%>
                        <%if (session.getAttribute("Logged on user")!= null){
                        	String username = session.getAttribute("Username").toString();
                        	
                        	//Show the Edit link only if user has authored the comment
                        	if (username.equals(comment.getCreated_by())) { %>
                       			<a href="javascript:void(0);" onclick="editComment(<%=comment_id%>)" id="commentEdit<%=comment_id%>">Edit</a> 
                       			<span class="commentEdit" name="<%=comment_id%>"></span>
                        	<%}
                        	
                        	// Show the delete link if the user has authored the comment or the comment's article
                        	if(username.equals(comment.getCreated_by()) || username.equals(article.getCreated_by())){ %>
                        		<a href="javascript:void(0);" onclick="deleteComment(<%=comment_id%>)" id="commentDelete<%=comment_id%>">Delete</a>
                        		<span class="commentDelete" name="<%=comment_id%>"> </span>
                        	<%}%>
                     	<%}%>
         
         
                </div>
               <%}%> <%-- end of for loop  --%>
             <%}%> <%-- end of Comments' if block --%>
                
                


            </div>

            <!-- Blog Sidebar Widgets Column -->
            <div class="col-md-4">

				<%--Search button --%>
				<div class="well">
                    <h4>Blog Search</h4>
                    <div class="input-group">
                    <form name="searchArticles" action="RequestArticle" method="get">
                        <input type="text" name="doSearch" class="form-control">
                        <span style="Display: Block" class="input-group-btn">
                            <button  id="searchbutton" class="btn btn-default" type="submit">
                                <span class="glyphicon glyphicon-search"></span>
                        </button>
                        </span>
                        </form>
                    </div>
                    <!-- /.input-group -->
                </div>
                
                <%--Only show the create article button if a user is logged in and has a session active --%>
				<%if (session.getAttribute("Logged on user") != null) {%>
				<div class="panel panel-default">
					<div class="panel-heading">
						<a href="CreateArticle.jsp"><button class="button">CREATE ARTICLE</button></a>
					</div>
				</div>
				<%}%>

           


            </div>

        </div>
        <!-- /.row -->

        <hr>

        <!-- Footer -->
        <footer>
            <div class="row">
                <div class="col-lg-12">
                    <p>Copyright &copy; HALPful Blogs - Blogging Website 2020</p>
                </div>
            </div>
            <!-- /.row -->
        </footer>

    </div>
    <!-- /.container -->

    <!-- jQuery -->
    <script src="js/jquery.js"></script>

    <script src="js/bootstrap.min.js"></script>
	<script src="lib/jquery-2.0.3.min.js"></script>
	<script src="lib/bootstrap-3.0.3/js/bootstrap.min.js"></script>
 
</body>
</html>