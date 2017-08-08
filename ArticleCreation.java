package teamhalp;

import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import teamhalp.*;
import teamhalp.dao.*;


/**
 * Servlet implementation class articleTransition
 */
@WebServlet("/ArticleCreation")
public class ArticleCreation extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ArticleCreation() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}
	@SuppressWarnings("deprecation")

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		
		if(session.getAttribute("Logged on user")==null){
			out.println("You have been logged out.... Redirecting");
	   		response.setHeader("Refresh","1;url=./Homepage.jsp");
		}
		
		ArticleDAO database = new ArticleDAO();
		String dateParameter =request.getParameter("articleDate");
		java.sql.Date sqlDate = null;

		// Check if the user picked a date
		if (dateParameter != null) {
			SimpleDateFormat sdf1 = new SimpleDateFormat("MM/dd/yyyy");
			java.util.Date utilDate =null;
			try {
				utilDate = sdf1.parse(dateParameter);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			sqlDate = new java.sql.Date(utilDate.getTime());
		//else, use today's date
		} else {
			long millis=System.currentTimeMillis(); 
			sqlDate = new java.sql.Date(millis);
		}
		String content = request.getParameter("content");
		Article a = new Article(request.getParameter("title"), content, ((User) session.getAttribute("Logged on user")).getUName(), sqlDate);		
		new ArticleDAO().saveArticle(a);

   		out.println("Thank you for posting.... Redirecting");
   		response.setHeader("Refresh","1;url=./UserHome.jsp");
	}

}
