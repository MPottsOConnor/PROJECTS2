package teamhalp.dao;

import java.sql.Date;

/**
 * Represents an article, which has a title and a body of text.
 *
 */
public class Article {

	private int article_id;
	private String title;
	private String content;
	private String created_by;
	private Date created_at;
	private Date updated_at;
	



	/**
	 * Creates a new {@link Article}.
	 * 
	 * @param id
	 *            the article's id
	 * @param title
	 *            the article's title
	 * @param body
	 *            the article's body
	 */
	public Article(String title, String content, String created_by, Date created_at) {
		this.title = title;
		this.content = content;
		this.created_by = created_by;
		this.created_at=created_at;
		this.updated_at = null;
	}
	
	public Article(int article_id, String title, String content, String created_by, Date created_at, Date updated_at) {
		this.article_id = article_id;
		this.title = title;
		this.content = content;
		this.created_by = created_by;
		this.created_at=created_at;
		this.updated_at = updated_at;
	}
	
	public void setArticle_id (int article_id) {
		this.article_id= article_id;
	}

	public int getArticle_id () {
		return article_id;
	}

	/**
	 * Gets the article's ID
	 * 
	 * @return
	 */
	public String getCreated_by() {
		return this.created_by;
	}

	/**
	 * Gets the article's title
	 * 
	 * @return
	 */
	public String getTitle() {
		return this.title;
	}

	/**
	 * Gets the article's body
	 * 
	 * @return
	 */
	public String getContent() {
		return this.content;
	}
	
	public Date getCreated_at() {
		return created_at;
	}

	public Date getUpdated_at() {
		return updated_at;
	}


	

	public void setTitle(String title) {
		this.title = title;
	}

	public void setContent(String content) {
		this.content = content;
	}


	public void setCreated_at(Date created_at) {
		this.created_at = created_at;
	}

	public void setUpdated_at(Date updated_at) {
		this.updated_at = updated_at;
	}
	
	

}