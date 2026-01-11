<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("title", "Détail Réservation "+request.getAttribute("billet.id")+" - Gestion Cinéma");
    request.setAttribute("contentPage", "/WEB-INF/jsp/reservation/detailReservationContent.jsp");
%>

<jsp:include page="/WEB-INF/jsp/layout/main.jsp" />
