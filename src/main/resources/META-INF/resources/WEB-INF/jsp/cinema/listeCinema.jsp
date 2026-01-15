<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("title", "Liste des Cinémas - Gestion Cinéma");
    request.setAttribute("contentPage", "/WEB-INF/jsp/cinema/listeCinemaContent.jsp");
%>
<jsp:forward page="/WEB-INF/jsp/layout/main.jsp" />
