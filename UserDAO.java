package teamhalp.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

public class UserDAO extends AbstractDAO<User> {

	@Override
	public User createItemFromResultSet(ResultSet rs) throws SQLException {
		int id = rs.getInt("user_id");
		String uname = rs.getString("uname");
		String fname = rs.getString("fname");
		String lname = rs.getString("lname");
		String pw = rs.getString("pw");
		String icon = rs.getString("icon");
		String email = rs.getString("email");
		String education = rs.getString("education");
		Date dob = rs.getDate("dob");
		String country = rs.getString("country");
		User user = new User(id, uname, fname, lname, pw, icon, email, education, dob, country);
		return user;
	}

	@Override
	public String getAll_SQL() {
		return "SELECT * FROM users";
	}

	@Override
	public String getById_SQL(int id) {
		return "SELECT * FROM users WHERE user_id=" + id;
	}

	public User getByUName(String uname) {
		String query = "SELECT * FROM users WHERE uname='" + uname + "'";
		List<User> list = doQuery(query);
		if (list.size() == 0)
			return null;
		else
			return list.get(0);
	}
	
	protected int getRecentUser_id() {
		try (Connection conn = Database.getConnection(); Statement stmt = conn.createStatement();) {
			ResultSet recentUser_id = stmt.executeQuery("SELECT MAX(user_id) AS id FROM users");
			recentUser_id.next();
			return recentUser_id.getInt("id");
		} catch (SQLException e) {
			System.err.println(e);
		}
		return 0;
	}
	
	public void saveUser(User newUser) {
		String update = "INSERT INTO users(uname, pw) VALUES('" + newUser.getUName() + "', '" + newUser.getPw() + "')";
		doUpdate(update);
		
		// After inserting the article into the database, retrieve the
		// auto-generated article_id then set it
		int newestUser_id = getRecentUser_id();
		newUser.setId(newestUser_id);
	}

	public void updateUser(User user) {
		String update = "UPDATE users SET uname='" + user.getUName() + "'"
		+ ((user.getFName() == null) ? "" : ", fname='" + user.getFName() + "'")
		+ ((user.getLName() == null)? "" : ", lname='" + user.getLName() + "'")
		+ ", pw='" + user.getPw()  + "'"
		+ ((user.getIcon() == null)? "" : ", icon='" + user.getIcon()  + "'") // add default icon
		+ ((user.getEmail() == null)? "" : ", email='" + user.getEmail() + "'")
		+ ((user.getEducation() == null)? "" : ", education='" + user.getEducation() + "'")
		+ ((user.getDoB() == null) ? "" : ", dob='" + user.getDoB() + "'")
		+ ((user.getCountry() == null)? "" : ", country='" + user.getCountry() + "'")
		+ " WHERE user_id=" + user.getId();
		doUpdate(update);
	}
	
	public void deleteUser(User user) {
		String update = "DELETE FROM users WHERE user_id=" + user.getId();
		doUpdate(update);
	}

}
