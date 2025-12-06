<%-- 
    Document   : logout
    Created on : 13 Sept 2025, 2:10:04 pm
    Author     : ziyad
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
//     request.getSession(false); 
    // Invalidate the session
    if (session != null) {
        session.invalidate();
    }

    // Redirect to login page
    response.sendRedirect("index.html"); // change to your login page
%>



