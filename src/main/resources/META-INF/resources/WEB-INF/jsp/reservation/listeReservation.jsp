<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setAttribute("title", "Liste des Réservations - Gestion Cinéma");
    request.setAttribute("contentPage", "/WEB-INF/jsp/reservation/listeReservationContent.jsp");
%>
<jsp:forward page="/WEB-INF/jsp/layout/main.jsp" />
