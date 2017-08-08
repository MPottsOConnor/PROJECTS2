<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
			<%@ page import ="teamhalp.dao.*, java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<style>
.dropdown-menu, .cog{
background-color: #baa378;
}
</style>
<title>NavBar2</title>
</head>
<body>
			<%-- Code for displaying the user's icon in the NavBar2 (which is for users logged in) --%>
			<%!User user;
			String srcString = "http://placehold.it/18x18";%>
			<%String realIconPath = getServletContext().getRealPath("/Icons/");
			String iconPath = realIconPath.substring(realIconPath.indexOf("TeamHalp")-1);
			
			user = (User)(session.getAttribute("Logged on user"));
			        if (user.getIcon()!= null) {
			        	 java.io.File f = new java.io.File(realIconPath+user.getIcon());
				       	if (f.exists() && f.canRead()) {
				       		String userIcon = user.getIcon();
				       		String thumbnail = iconPath + "thumbnail-" +userIcon.substring(userIcon.indexOf("-")+1, userIcon.indexOf(".")) + ".png";
				       		srcString = thumbnail;
				       	}
			        }
			%>
			
	<nav class="navbar navbar-default navbar-fixed-top">
	<div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target="#myNavbar">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>

		</div>
		<div class="collapse navbar-collapse" id="myNavbar">

			<ul class="nav navbar-nav navbar-right">
				<li><a href="Homepage.jsp">HOME</a></li>
				<li name="UserHome"><a href="UserHome.jsp">MY ARTICLES</a>
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown"> <img src=<%=srcString %>
						class="profile-image img-circle"> <%=user.getUName()%> <b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a href="UserProfile.jsp"><i class="cog"></i>Edit
								Profile</a></li>
						<li class="divider"></li>
						<li><a href="UserHome?logout"><i class="cog"></i> Sign-out</a></li>
					</ul></li>

			</ul>

		</div>
	</div>
	</nav>

</body>
</html>