<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.org.twopm.generic.Constants"%>
<%@page import="com.org.twopm.login.Login"%>
<%@page import="java.sql.Connection,java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="/pages/common/header.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en"> 
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/style.css">
</head>
<body>

<%
	if(session.getAttribute(Constants.USER_ID) != null){
		response.sendRedirect(request.getContextPath()+"/pages/common/home.jsp");
	}
	
	String userName = request.getParameter("userName") == null ? "" : request.getParameter("userName");
	String password = request.getParameter("password") == null ? "" : request.getParameter("password") ;
	String page1 = request.getParameter("page1");
	Integer userId = null;
	LinkedHashMap<String, String> userTeamMap = null;

	if(page1 != null && page1.equals("submit")){
		Login login = new Login();
		userId = login.verifyUser(userName, password);	
		if(userId != 0){
			session.setAttribute(Constants.USER_ID, userId);
			session.setAttribute(Constants.USER_NAME, userName);
			List<String> list = login.getUserMenu(userName);
			session.setAttribute("menu", list);
			response.sendRedirect(request.getContextPath()+"/pages/common/home.jsp");
		}
		login = null;
	}
%>

  <section class="container">
    <div class="login">
      <h1>Login</h1>
      <form method="post" action="">
        <p><input type="text" name="userName" value="<%=userName %>" placeholder="Username"></p>
        <p><input type="password" name="password" value="<%=password %>" placeholder="Password"></p>
        <%	
        	if(userId != null && userId == 0){
        	%><p><label>Wrong username or password</label></p><% 
        	}
        	if(userTeamMap != null && userTeamMap.size() == 0){
        	%><p><label>No Team Mapping Exist</label></p><% 
        	}
        %>
        
        <p class="remember_me">
          <label>
            <input type="checkbox" name="remember_me" id="remember_me">
            Remember me on this computer
          </label>
        </p>
        <p class="submit">
        	<input type="submit" name="commit" value="Login">&nbsp;&nbsp;
        	<input style="float: right; text-align: right;" type="button" class="button"  name="signUP" value="SignUp" onclick="location.href='<%=contextPath%>/pages/login/createUser.jsp'">
        </p>
        <input type="hidden" name="page1" value="submit" />
      </form>
    </div>

    <div class="login-help">
      <p>Forgot your password? <a href="<%=contextPath%>/pages/login/forgotPassword.jsp">Click here to reset it.</a></p>
    </div>
  </section>
  
  <%
  	userId = null;
  	finalize();
  %>
</body>
<%@ include file="/pages/common/footer.jsp" %>
</html>
