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
  
  <script type="text/javascript">
  function resetform() {
	  document.getElementById("changeForm").reset();
	  }
  
  </script>
</head>
<body>

<%
	Integer userId= (Integer)session.getAttribute(Constants.USER_ID);
%>

  <section class="container">
    <div class="login">
      <h1>Change password</h1>
      <form method="post" id="changeForm" action="">
        <p><input type="password" name="currentPassword" value="" placeholder="CurrentPassword"></p>
        <p><input type="password" name="newPassword" value="" placeholder="NewPassword"></p>
        <p><input type="password" name="reEnterPassword" value="" placeholder="ReEnterPassword"></p>
                
        
        <p class="submit">
        	<input type="button" name="reset" value="Reset" onClick="resetform()">&nbsp;&nbsp;
        	
        	<input style="float: right; text-align: right;" type="button" class="button"  name="change" value="Change" onclick="location.href='<%=contextPath%>/pages/login/changePassword.jsp'">
        </p>
        <input type="hidden" name="page1" value="submit" />
      </form>
    </div>

    
  </section>
  
  <%
  	userId = null;
  	finalize();
  %>
</body>
<%@ include file="/pages/common/footer.jsp" %>
</html>
