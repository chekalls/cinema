<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("title", "Liste des Genres - Gestion Cinéma");
    request.setAttribute("contentPage", "/WEB-INF/jsp/genre/listeGenreContent.jsp");
%>
<jsp:forward page="/WEB-INF/jsp/layout/main.jsp" />
