<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../layout/main.jsp">
    <jsp:param name="title" value="${isEdit ? 'Modifier' : 'Nouveau'} prix"/>
    <jsp:param name="content" value="/WEB-INF/jsp/prixBillet/formContent.jsp"/>
</jsp:include>
