<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("title", "Liste des Salles - Gestion Cinéma");
    request.setAttribute("contentPage", "/WEB-INF/jsp/salle/listeSalleContent.jsp");
%>
<jsp:forward page="/WEB-INF/jsp/layout/main.jsp" />
