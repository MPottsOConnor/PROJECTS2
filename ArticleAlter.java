package teamhalp;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import teamhalp.dao.Article;
import teamhalp.dao.ArticleDAO;

/**
 * Servlet implementation class ArticleAlter
 */
@WebServlet("/ArticleAlter")
public class ArticleAlter extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ArticleAlter() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// check if article is to be deleted
		if (request.getParameter("deleteArticle") != null) {
			int article_id = Integer.parseInt(request.getParameter("deleteArticle"));
			ArticleDAO accessor = new ArticleDAO();
			Article articleToDelete = accessor.getById(article_id);
			accessor.deleteArticle(articleToDelete);
		
		// code for article being edited	
		} else if (request.getParameter("editArticle") != null) {
			int article_id = Integer.parseInt(request.getParameter("editArticle"));
			String newContent = request.getParameter("newContent");
			ArticleDAO accessor = new ArticleDAO();
			Article articleToEdit = accessor.getById(article_id);
			articleToEdit.setContent(newContent);
			accessor.updateArticle(articleToEdit);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
