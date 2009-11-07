<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
<link title="styles" href="css/community_server.css" type="text/css" rel="stylesheet" media="all"/>
<title>OneSwarm Community Server Signup</title></head>

<jsp:include page="header.jsp"/>

<%@ page import="edu.washington.cs.oneswarm.community2.server.*" %>
<%@ page import="edu.washington.cs.oneswarm.community2.shared.*" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.washington.cs.oneswarm.community2.utils.*" %>
<%@ page import="nl.captcha.Captcha" %>

<%!
	CommunityDAO dao = CommunityDAO.get();
%>

<%	
boolean badCreate = false;
if( request.getMethod().equals("POST") ) {
	String username = request.getParameter("username");
	String password1 = request.getParameter("password");
	String password2 = request.getParameter("password2");
	
	request.setCharacterEncoding("UTF-8");
	
	if( System.getProperty(EmbeddedServer.Setting.REQUIRE_CAPTCHA.getKey()).equals(
			  Boolean.TRUE.toString()) ) {  
		Captcha captcha = (Captcha)session.getAttribute(Captcha.NAME);
		String ans = request.getParameter("captchaAnswer");
		if( captcha.isCorrect(ans) == false ) { 
			badCreate = true;
			%>
			<div class="account_creation_error">
			Your response did not match the text shown in the image below.
			</div>	
	<% 	}
	}
	
	if( username.length() > 64 ) { 
		badCreate = true; 
		%>
		<div class="account_creation_error">
		Username must be less than 64 characters. 
		</div>	
<%	}
	else if( password1.equals(password2) == false ) {
		badCreate = true; %>
	
		<div class="account_creation_error">
		Passwords do not match. 
		</div>
<% 		
	} else if( password1.length() < 4 ) { 
		badCreate = true; %>  
	
		<div class="account_creation_error">
		Password must be at least 4 characters or more. 
		</div>		
<% 		
	} 

	if( badCreate == false ) {
		try {
			dao.createAccount(username, password1, CommunityDAO.UserRole.USER);
%>
			<div>
			Account created<br/> 
			<h3><a href="/logon.jsp">Log in</a></h3>
			</div>		
<%		
		} catch( DuplicateAccountException e ) { 
			badCreate = true; %>
			<div class="account_creation_error">
			That username is already taken. Please choose another. 
			</div>
<%		}
	}
}
%>

<br><br>

<% if( request.getMethod().equals("GET") || badCreate ) { %>

<form action="/signup.jsp" method=post>
<table border="0" cellpadding="5">
  <tr>
    <td width="125px"><div align="right">Username:</div></td>
    <td width="125px"><input type="text" name="username" width="150px"></td>
  </tr>
  <tr>
    <td><div align="right">Password: </div></td>
    <td><input type="password" width="150px" name="password"></td>
  </tr>
  <tr>
    <td><div align="right">Repeat password: </div></td>
    <td><input type="password" width="150px" name="password2"></td>
  </tr>
  
  <% if( System.getProperty(EmbeddedServer.Setting.REQUIRE_CAPTCHA.getKey()).equals(
		  Boolean.TRUE.toString()) ) { %>
  <tr>
  	<td></td><td><img src="captcha.png" /></td>
  </tr>
  <% } %>
  <tr>
  	<td><div align="right">Text above: </div></td>
    <td><input type="text" width="150px" name="captchaAnswer"></td>
  </tr>
  
  <tr>
  	<th colspan="2"><input type="submit" value="Create account"></th>
  </tr>
</table>
</form>

<% } %> 

</html>