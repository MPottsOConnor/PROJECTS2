package teamhalp.dao;

import java.util.List;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.util.HashSet;
import java.sql.*;

/**
 * A half-implemented DAO class. Currently contains methods to get all
 * {@link Article}s, and get a single {@link Article} by ID.
 * 
 * <p>
 * A fully implemented DAO class would also contain (at minimum) methods to
 * update {@link Article}s if they've changed, add new ones, and delete existing
 * ones.
 * </p>
 *
 */
public class ArticleDAO extends AbstractDAO<Article> {

	@Override
	public Article createItemFromResultSet(ResultSet rs) throws SQLException {
		int id = rs.getInt("article_id");
		String title = rs.getString("title");
		String content = rs.getString("content");
		String created_by = rs.getString("created_by");
		Date created_at = rs.getDate("created_at");
		Date updated_at = rs.getDate("updated_at");
		return new Article(id, title, content, created_by, created_at, updated_at);
	}

	@Override
	public String getAll_SQL() {
		return "SELECT * FROM articles ORDER BY created_at DESC";
	}

	@Override
	public String getById_SQL(int id) {
		return "SELECT * FROM articles WHERE article_id = " + id;
	}

	public String getByUserId_SQL(int user_id) {
		return "SELECT * FROM articles WHERE created_by = " + user_id;
	}

	public List<Article> getByUsername(String uname) {
		String query = "SELECT * FROM articles WHERE created_by='" + uname + "'";
		List<Article> list = doQuery(query);
		if (list.size() == 0)
			return null;
		else
			return list;
	}

	protected int getRecentArticle_idFromArticles() {
		try (Connection conn = Database.getConnection(); Statement stmt = conn.createStatement();) {
			ResultSet recentArticle_id = stmt.executeQuery("SELECT MAX(article_id) AS id FROM articles");
			recentArticle_id.next();
			return recentArticle_id.getInt("id");
		} catch (SQLException e) {
			System.err.println(e);
		}
		return 0;
	}

	public void saveArticle(Article article) {
		String update = "INSERT INTO articles(title, content, created_by, created_at) VALUES(?, ?,'"
				+ article.getCreated_by() + "','" + article.getCreated_at() + "')";
		doUpdate(update, article);

		// After inserting the article into the database, retrieve the
		// auto-generated article_id then set it
		int newestArticle_id = getRecentArticle_idFromArticles();
		article.setArticle_id(newestArticle_id);
	}

	public void deleteArticle(Article article) {
		String update = "DELETE FROM articles WHERE article_id=" + article.getArticle_id();
		doUpdate(update);
	}

	public void updateArticle(Article article) {
		String update = "UPDATE articles SET " + "title=?" + ", content=?" + ", created_at='" + article.getCreated_at()
				+ "'" + (article.getUpdated_at() == null ? "" : ", updated_at='" + article.getUpdated_at() + "'")
				+ " WHERE article_id=" + article.getArticle_id();
		doUpdate(update, article);
	}

	// implement a different doUpdate method than the superclass one, as we need
	// to use a PreparedStatement (in the directly above method)
	// Does not override since it has different parameters
	// Note the superclass's doUpdate method is still used in this class and
	// others
	protected void doUpdate(String update, Article article) {
		try (Connection conn = Database.getConnection();) {
			PreparedStatement stmt = conn.prepareStatement(update);
			stmt.setString(1, article.getTitle());
			stmt.setString(2, article.getContent());
			stmt.executeUpdate();
		} catch (SQLException e) {
			System.err.println(e);
		}

	}

	public List<Article> searchForArticle(String keyword) {
		String searchQuery = "SELECT * FROM articles WHERE UPPER(title) LIKE '%" + keyword.toUpperCase() + "%'"
									+ " OR UPPER(content) LIKE '%" + keyword.toUpperCase() + "%'";
		List<Article> searchList = doQuery(searchQuery);
		
		if (searchList.size() == 0) {
			return null;
		} else {
			return searchList;
		}
	}
	
	public List<Article> searchForArticles(String keyword, List<Article> articles) {
		List<Article> searchResult= new ArrayList<Article>();
		for (Article article : articles) {
			if (article.getTitle().contains(keyword) || article.getContent().contains(keyword)) {
				searchResult.add(article);
			}
		}
		
		if (searchResult.size() == 0) {
			return null;
		} else {
			return searchResult;
		}
	}
}