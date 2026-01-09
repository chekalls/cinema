<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("title", "À propos - Gestion Cinéma");
    request.setAttribute("contentPage", "/WEB-INF/jsp/aboutContent.jsp");
%>
<jsp:forward page="/WEB-INF/jsp/layout/main.jsp" />
