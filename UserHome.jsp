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
    

    <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Black+Ops+One" />
    <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Rock+Salt" />
 
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	
    
    <title>HALP User HomePage</title>
    
    <style>
    <%@include file="assets/homepage.css"%>
    </style>

</head>
<body>
<%-- First check if a user is logged on or an author parameter exists so we know whose blog we should display, 
		if neither exist then redirect to homepage --%>
<%if (session.getAttribute("Logged on user")==null && request.getParameter("author")==null) { 
	response.sendRedirect("Homepage.jsp"); 
	return;
 }%>

<!-- Navigation bar (depending on whether user is logged on or not) -->
<%if(session.getAttribute("Logged on user")==null){%>
	<jsp:include page="WEB-INF/NavBar1.jsp" />
<%} else{%>
	<jsp:include page="WEB-INF/NavBar2.jsp" />
<%}%>


<div class="jumbotron text-center">
		<h1 style="font-family:  Black Ops One; font-size: 90px; font-style: normal; font-variant: normal; font-weight: 500; color:wheat" ><i>H  A  L  P  f  u  l</i></h1>
		<p style="font-family: Rock Salt; font-size: 40px; color: whitesmoke">B l o g s</p>
</div>

	<!-- Body -->
	<div class="container">
		<div class="row">
			<div class="col-md-8">
				
					
				<%
				List<Article> articles = null; 
			    String author;
			    String title = "";
				String messages = "";
				boolean differentAuthor = request.getParameter("author")!= null;
				
				// If a user's name was clicked, display their blog, otherwise display the logged on user's blog
	            author = differentAuthor ? request.getParameter("author") :
    				((User)session.getAttribute("Logged on user")).getUName();
				
				// check if the articles are supposed to be search results and/or sorted
				boolean isSorted =request.getParameter("sorted") != null;
				boolean isSearch =request.getParameter("search") != null;
				// if there is a searched and/or sorted article list, assign to articles to use it
				if (isSearch || isSorted) {
					articles = (List<Article>)(session.getAttribute("Article List"));
					//set the title of the page according to if there was a search and/or if there is a sort 
					title += (isSearch ? "Search results for: " + session.getAttribute("keyword") : ""); 
					String joinedStart = (title.isEmpty() ? "S" : ", s");
					title += (isSorted ? joinedStart + "orted by: " + session.getAttribute("sortCriteria") : "");
					if (articles == null) {
						messages += "Cannot find any articles.\n";
					}	
				// else, get author's articles
				} else {
					// page heading should either be "(someone else)'s Blog", or "Your blog"
	                title = request.getParameter("author")!= null ? author + "'s Blog" : "Your blog";;
	                ArticleDAO accessor = new ArticleDAO();
					articles = accessor.getByUsername(author);
					if (articles==null &&session.getAttribute("Logged on user")!=null && ((User)session.getAttribute("Logged on user")).getUName().equals(author)) {
						title = "Hello " + author + ", welcome to your blog space.";
						messages += "You are invited to contribute to our community by creating an article.<br>"
									+ "Otherwise, return home to view everyones' articles.<hr>";
					}
				}%>
				
				<h2><%=title %></h2>
				<p><%=messages %></p>
				
				
				<%-- Generates all articles in a loop, producing only 5 results per page
				 First, calculate the startIndex and endIndex (note if articles is null then skip this code and the for loop) --%>
			<%  session.setAttribute("Article List", articles);
				int startIndex = 0;	//start Index of this page (taking page parameter into account later on)
				int endIndex = -1;	// endIndex to -1 so that loop doesn't start if articles list is empty
				int pages = 1;
				
				if(articles != null) {
					int offset = articles.size()%5;	// offset to be used for the last page
					//total number of pages for the list of articles, rounded up
					pages = (int) Math.ceil((double)articles.size()/5);	
					
					int currentPage=0;
					if(request.getParameter("page")!= null){	//if there is a 'page' parameter, use it
						int pageParameter = Integer.parseInt(request.getParameter("page"));
						currentPage = pageParameter;
					} else {
						currentPage=1;		//if no page parameter, show first page
					}
					// for example, if 12 articles, then currentPage 1 -> start 0, currentPage 2 -> 5, currentPage 3 -> 10
					startIndex= (currentPage-1)*5;
					//if currentPage is the last page, assign endIndex to end of the list, else assign endIndex to 4 ahead of startIndex
					endIndex = (currentPage==pages ? articles.size()-1 : startIndex + 4);
					// Actual for loop starts here (above code was sorting the articles, and calculating start and end Indices)
				}
				// finally start the for loop, if there are articles in the list
				for(int i = startIndex; i <= endIndex; i++) {
					Article article = articles.get(i);
					int article_id = article.getArticle_id();
					// Get number of comments to display it for each article
					List<Comment> comments = new CommentDAO().getByArticle_id(article.getArticle_id());
					int numberOfComments  = (comments == null? 0 : comments.size());%>
					<article>
					<h3><a href="Article.jsp?article=<%=article.getArticle_id()%>"><%=article.getTitle()%></a></h3>

			        <div class="row">
			          	<div class="col-sm-6 col-md-6">

			          		&nbsp;&nbsp;<span class="glyphicon glyphicon-bookmark"></span>Created by <a href="UserHome.jsp?author=<%=author%>"><%=author%></a>
			          	</div>
			          	<div class="col-sm-6 col-md-6">
			          		<span class="glyphicon glyphicon-pencil"></span> 
			          		<a href="Article.jsp?article=<%=article_id%>#comments">
							
			          		<!-- Display number of comments -->
							<%=numberOfComments + (numberOfComments==1? " Comment" : " Comments")%></a> &nbsp;&nbsp;
							<span class="glyphicon glyphicon-time"></span><%=article.getCreated_at()%>			          		
			          	</div>
			          </div>

			          <hr>

			          
					  <%-- display up to 250 characters of the article as a preview, or 100 if search results --%>
						<% int contentLength= isSearch ? 100 : 250;
						int endIndexOfPreview = Math.min(contentLength, article.getContent().length());
					  	String threeDots = endIndexOfPreview ==contentLength ? "..." : "";%>
						<p class="lead"><%=article.getContent().substring(0, endIndexOfPreview) + threeDots%></p>
						
			          	<%-- 'Continue reading' link --%>
						<p class="text-right">
				          <a href="Article.jsp?article=<%=article_id%>">continue reading...</a>
				      	</p><hr><br><br>
					</article>
				<%}%> <%--End of the for loop for article generation --%>

			
				<%-- This code block finds out whether to show Previous and Next buttons at bottom of page, 
						and what parameter to attach to it--%>
				<ul class="pager"> 
					<%! String searchAndSortParameters = ""; %>
					<%  searchAndSortParameters = (isSearch ? "&search=true" : "");
						searchAndSortParameters += (isSorted ? "&sorted=true" : "");
						
					%>
					<%if(request.getParameter("page")!=null){
						int pageParameter = Integer.parseInt(request.getParameter("page"));
						// display "previous" button at the bottom of page Unless page is 1
						boolean shouldDisplayPrevious = pageParameter != 1;
						if (shouldDisplayPrevious) {%>	
							<li class="previous"><a href="UserHome.jsp?page=<%=(pageParameter-1) + searchAndSortParameters%>">&larr; Previous</a></li>
						<%}%>
					<%}%>
				<%	boolean shouldDisplayNext=false; 
					int pageParameter=0;
				// if there is no page parameter but the total number of pages is more than 1, then set next button to go to page2
				if(request.getParameter("page")==null && pages>1){
					shouldDisplayNext=true;
					pageParameter=1;
				// if page parameter exists, use it
				} else if (request.getParameter("page")!=null) {
					pageParameter = Integer.parseInt(request.getParameter("page"));
					//if the pageParameter(which tells us which page we're on) is less than total number of pages, display the button 
					if (pageParameter<pages) {
						shouldDisplayNext=true;
					}
				}
				if (shouldDisplayNext) {%>	
					<li class="next"><a href="UserHome.jsp?page=<%=(pageParameter+1) + searchAndSortParameters%>">&rarr; Next </a></li>
				<%}%>
				</ul>

			</div>
			<div class="col-md-4">


				<%--Search button --%>
				<div class="well">
                    <h4>Blog Search</h4>
                    <div class="input-group">
                    <form name="searchArticles" action="RequestArticle" method="get">
                    <%if(differentAuthor) {%> <input type="hidden" name="differentAuthor" value="<%=author%>"/> <%}%>
                    <input type="hidden" name="onlyUserArticles"/>
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
                
                <%-- Sorting feature --%>
                <div class="well">
                    <h4>Sort Articles</h4>
                    <div class="input-group">
                    <form name="sortArticles" action="RequestArticle" method="get">
                    <input type="hidden" name="onlyUserArticles" value="sort"/>
                    <%if(differentAuthor) {%> <input type="hidden" name="differentAuthor" value="<%=author%>"/> <%}%>
                    <% if (isSearch) {%><input type="hidden" name="alreadySearch" value="search"/>              <%}%>
                     <select title="Select your search criteria" class="selectpicker" name="doSort" required >
                        <option selected disabled value=""></option>
					  	<option value="title-asc" >Title &#x25B2</option>
					  	<option value="title-desc">Title &#x25BC</option>
					  	<option value="date-asc">Date &#x25B2</option>
					  	<option value="date-desc">Date &#x25BC</option>
					  </select>
                      <button class="btn btn-default" type="submit">Sort!</button>
                    </form>
                    </div>
                    <!-- /.input-group -->
                </div>
				
				<%-- Display a CREATE ARTICLE button if a user is logged in --%>
				<%if(session.getAttribute("Logged on user")!= null) {%>
				<div class="panel panel-default">
					<div class="panel-heading">
						<a href="CreateArticle.jsp"><button class="button" style="width:325px">CREATE ARTICLE</button></a>
					</div>
				</div>
				<%}%>	<%-- End for loop of article generation --%>

			</div>
		</div>
	</div>
	
	

	
	

	<!-- Footer -->
	<footer>
		<div class="container">
			<hr />
			<p class="text-center">Copyright &copy; HALPful Blogs - Blogging Website 2020. All rights reserved.</p>
		</div>
	</footer>

	<!-- Jquery and Bootstrap Script files -->
	<script src="lib/jquery-2.0.3.min.js"></script>
	<script src="lib/bootstrap-3.0.3/js/bootstrap.min.js"></script>



</body>
</html>
