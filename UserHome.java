package teamhalp;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.parser.Cookie;

import teamhalp.dao.Database;
import teamhalp.dao.User;
import teamhalp.dao.UserDAO;

/**
 * Servlet implementation class UserHome
 */
@WebServlet("/UserHome")
public class UserHome extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserHome() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
			doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
        
		HttpSession session = request.getSession();
		UserDAO userDao = new UserDAO();
		
		
		Enumeration<String> parameters = request.getParameterNames();
		
		
		while(parameters.hasMoreElements()) {
			
			String parameter = parameters.nextElement();
			switch (parameter) {
			// If user is logging in
			case ("login"):
				doLogin(request, userDao, response, session);
				break;
				// If someone is registering a new account
			case ("register"):
				doRegister(request, userDao, response);
				break;
			// If user is updating their profile
			case ("userupdate"):
				try {
					doUpdateUser(request, userDao, response, session);
				} catch (ParseException e) {
					e.printStackTrace();
				}
				break;
			//if user is deleting their account
			case ("userdeletion"):
				doUserDelete(request, userDao, response, session);
				break;
			case ("logout"):
				session.invalidate();
	   			response.getWriter().println("Logging out...");
	   			response.setHeader("Refresh","1;url=./Homepage.jsp");
			}
		}		
	}

	private void doUserDelete(HttpServletRequest request, UserDAO userDao, HttpServletResponse response,
			HttpSession session) throws ServletException, IOException {
		User logged_on_user = (User) (session.getAttribute("Logged on user"));
		String username = logged_on_user.getUName();
		User user = (userDao.getByUName(username));
		userDao.deleteUser(user);
		session.invalidate();
		// redirect to Homepage Page
		response.sendRedirect("Homepage.jsp");
	}

	private void doUpdateUser(HttpServletRequest request, UserDAO userDao, HttpServletResponse response,
		HttpSession session) throws ServletException, IOException, ParseException {
		//  get username from session and store it in a String object
		User logged_on_user = (User) (session.getAttribute("Logged on user"));
		String username = logged_on_user.getUName();
		User user = (userDao.getByUName(username));
		
		user.setPw(request.getParameter("password"));
		user.setCountry(request.getParameter("country"));
		// get Date from request parameter
		java.sql.Date date = null;
		// process the date parameter before use
		if (request.getParameter("date") != null && !request.getParameter("date").isEmpty()) {
			String dateString = request.getParameter("date");
			SimpleDateFormat formatter = null;
			if (dateString.contains("-")) {
				formatter = new SimpleDateFormat("yyyy-MM-dd");
			} else {
				formatter = new SimpleDateFormat("MM/dd/yyyy");
			}
			java.util.Date parsed = formatter.parse(dateString);
			date = new java.sql.Date(parsed.getTime());
		}
		user.setDoB(date);
		user.setEducation(request.getParameter("education"));
		user.setEmail(request.getParameter("useremail"));
		user.setFName(request.getParameter("firstname"));
		user.setLName(request.getParameter("lastname"));
		userDao.updateUser(user);
		session.setAttribute("Logged on user", userDao.getByUName(username));
		// redirect to User Profile Page
		response.sendRedirect("UserProfile.jsp");
	}

	private void doLogin(HttpServletRequest request, UserDAO userDao, HttpServletResponse response, HttpSession session)
			throws IOException {
		PrintWriter out = response.getWriter();
		String userPassword = request.getParameter("psw");
		String userName = request.getParameter("uname");
		List<User> users = userDao.getAll();
		if (users == null) {
			out.println("Cannot access database for loggin in. Please consult an Admin.");
			response.setHeader("Refresh","1;url=./Homepage.jsp");
			return;
		}
		// go through users in the database
		for (User user : users) {
			// if username and password matches, log user in
			if (user.getUName().equals(userName) && user.getPw().equals(userPassword)) {
				out.println("Welcome back, please wait while we redirect you...");
				session.setAttribute("Logged on user", user);
				session.setAttribute("Username", userName);
				response.setHeader("Refresh","1;url=./UserHome.jsp");
				return;
			//if username matches but password doesn't, alert the user
			} else if (user.getUName().equals(userName) && !user.getPw().equals(userPassword)) {
				out.println("Incorrect password.");
				response.setHeader("Refresh","1;url=./Login.html");
				return;

			}
		}
		// if the username does not match any of the users in the database, alert user
		out.println("Username does not exist.");
		response.setHeader("Refresh","1;url=./Login.html");
	}

	private void doRegister(HttpServletRequest request, UserDAO userDao, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String username = request.getParameter("username");
		List<String> usernames = new ArrayList<String>();
		List<User> users = userDao.getAll();
		if (users == null) {
			response.getWriter().println("Cannot access database to register. Please consult an Admin.");
			response.setHeader("Refresh","1;url=./Homepage.jsp");
			return;
		}
		for (User user : users) {
			usernames.add(user.getUName());
		}
		
		String gRecaptchaResponse = request
				.getParameter("g-recaptcha-response");
		boolean verification = VerifyRecaptcha.verify(gRecaptchaResponse);
		
		// check if the username is valid for register
		if (usernames.contains(username)) {
			// alert the user "Username has already been registered!!!"
			response.getWriter().println("Username has already been registered!!!");
			response.setHeader("Refresh","1;url=./Registration.html");
		// check recaptcha
		} else if (verification) {
			String pw = request.getParameter("password");
			String email = request.getParameter("useremail");
			User user = new User(username, pw);
			// save new user into db			
			userDao.saveUser(user);
			user.setEmail(email);
			userDao.updateUser(user);
			// CurrentUser.setUser(userDao.getByUName(username));
			session.setAttribute("Logged on user", userDao.getByUName(username));
			session.setAttribute("Username", username);
			// redirect to User Profile Page
			response.getWriter().println("Thanks for joining us! :) Please wait one second");
			response.setHeader("Refresh","1;url=./UserProfile.jsp");
		} else {
			response.getWriter().println("Please verify you are not a robot!!!");
			response.setHeader("Refresh","1;url=./Registration.html");
		}
	}
	
}
