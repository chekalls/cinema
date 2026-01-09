<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("title", "Liste des Films - Gestion Cinéma");
    request.setAttribute("contentPage", "/WEB-INF/jsp/film/listeFilmContent.jsp");
%>
<jsp:forward page="/WEB-INF/jsp/layout/main.jsp" />
