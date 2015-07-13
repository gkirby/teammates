<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="teammates.common.util.Const"%>
<%@ page import="teammates.common.util.TimeHelper"%>
<c:set var="showAll" value="${data.bundle.complete}" />

<c:if test="${data.allSectionsSelected}">
    <div class="panel panel-warning">
        <div class="panel-heading<c:if test="${not showAll}"> ajax_response_rate_submit</c:if>">
            <form style="display: none;" id="responseRate" class="responseRateForm" action="<%=Const.ActionURIs.INSTRUCTOR_FEEDBACK_RESULTS_PAGE%>">
                <input type="hidden" name="<%=Const.ParamsNames.COURSE_ID%>" value="${data.bundle.feedbackSession.courseId}">
                <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_SESSION_NAME%>" value="${data.bundle.feedbackSession.feedbackSessionName}">
                <input type="hidden" name="<%=Const.ParamsNames.USER_ID%>" value="${data.account.googleId}">
                <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_QUESTION_NUMBER%>" value="-1">
            </form>
            <div class='display-icon pull-right'>
                <span class="glyphicon${showAll ? ' glyphicon-chevron-up' : ' glyphicon-chevron-down'} pull-right"></span>
            </div>
            Participants who have not responded to any question
        </div>
        <div class="panel-collapse collapse<c:if test="${showAll}"> in</c:if>" id="responseStatus">
            <c:if test="${showAll}">
                <c:choose>
                    <c:when test="${data.allSectionsSelected and not empty data.bundle.responseStatus.noResponse}">
                        <div class="panel-body padding-0">
                            <table class="table table-striped table-bordered margin-0">
                                <thead class="background-color-medium-gray text-color-gray font-weight-normal">
                                    <tr>
                                        <th id="button_sortFromTeam"
                                            class="button-sort-ascending"
                                            onclick="toggleSort(this,1)"
                                            style="width: 15%;">Team<span
                                            class="icon-sort unsorted"></span>
                                        </th>
                                        <th id="button_sortTo" class="button-sort-none"
                                            onclick="toggleSort(this,2)"
                                            style="width: 15%;">Name<span
                                            class="icon-sort unsorted"></span>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${data.bundle.responseStatus.studentsWhoDidNotRespondToAnyQuestion}" var="studentEmail">
                                        <c:set var="studentName" value="${data.bundle.responseStatus.emailNameTable[studentEmail]}" />
                                        <c:if test="${not empty studentName}">
                                            <tr>
                                                <td>
                                                    <c:set var="instructorsTeamName"><%= Const.USER_TEAM_FOR_INSTRUCTOR %></c:set>
                                                    <c:out value="${data.bundle.responseStatus.emailTeamNameTable[studentEmail]}"
                                                           default="<i>${instructorsTeamName}</i>"
                                                           escapeXml="false" />
                                                </td>
                                                <td>${studentName}</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="panel-body">
                            All students have responded to some questions in this session.
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </div>
    </div>
</c:if>