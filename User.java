package teamhalp.dao;

import java.util.Date;

public class User {
	private int user_id; // invisible to users
	private String uname;
	private String fname;
	private String lname;
	private String pw;
	private String icon;
	private String email;
	private String education;
	private Date dob;
	private String country;

	public User(String uname, String pw) {
		this.uname = uname;
		this.pw = pw;
		// this.email = email;
	}

	public User(int id, String uname, String fname, String lname, String pw, String icon, String email, 
			String education, Date dob, String country) {
		this.user_id = id;
		this.uname = uname;
		this.fname = fname;
		this.lname = lname;
		this.pw = pw;
		this.icon = icon;
		this.email = email;
		this.education = education;
		this.dob = dob;
		this.country = country;
	}

	public int getId() {
		return user_id;
	}
	
	public void setId(int user_id) {
		this.user_id = user_id;
	}

	public String getUName() {
		return uname;
	}

	public String getFName() {
		return fname;
	}

	public String getLName() {
		return lname;
	}

	public String getPw() {
		return pw;
	}

	public String getIcon() {
		return icon;
	}

	public String getEmail() {
		return email;
	}

	public Date getDoB() {
		return dob;
	}

	public String getEducation() {
		return education;
	}

	public String getCountry() {
		return country;
	}

	public void setFName(String fname) {
		this.fname = fname;
	}

	public void setLName(String lname) {
		this.lname = lname;
	}

	// read value from parameter and store it in the object of User
	public void setIcon(String icon) {
		this.icon = icon;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setUname(String uname) {
		this.uname = uname;
	}

	public void setDoB(Date dob) {
		this.dob = dob;
	}

	public void setEducation(String education) {
		this.education = education;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	// user can change uname and pw
	public void setUName(String uname) {
		this.uname = uname;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

}
