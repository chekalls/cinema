<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("title", "Liste des Séances - Gestion Cinéma");
    request.setAttribute("contentPage", "/WEB-INF/jsp/seance/listeSeanceContent.jsp");
%>
<jsp:forward page="/WEB-INF/jsp/layout/main.jsp" />
