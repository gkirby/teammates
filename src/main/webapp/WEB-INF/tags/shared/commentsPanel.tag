<%@ tag description="Panel for student comments" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags/shared" prefix="shared" %>
<%@ tag import="teammates.common.util.Const" %>
<%@ tag import="teammates.common.datatransfer.CommentParticipantType" %>
<%@ attribute name="commentsForStudentsTables" type="java.util.Collection" required="true" %>
<%@ attribute name="courseId" %>
<%@ attribute name="viewingDraft" %>
<%@ attribute name="forRecordsPage" %>
<c:choose>
    <c:when test="${viewingDraft}">
        <c:set var="bodyTitle" value="Comment drafts" />
    </c:when>
    <c:when test="${forRecordsPage}">
        <c:set var="bodyTitle" value="Comments for ${fn:escapeXml(data.studentName)}" />
    </c:when>
    <c:otherwise>
        <c:set var="bodyTitle" value="Comments for students" />
    </c:otherwise>
</c:choose>
<div class="panel panel-primary student-comments-panel">
    <div class="panel-heading cursor-pointer"  data-toggle="collapse"
        data-target="#panelBodyCollapse" onclick="toggleChevron(this)">
        <div class="display-icon pull-right">
            <span class="glyphicon glyphicon-chevron-up pull-right"></span>
        </div>
        <strong>${bodyTitle}</strong>
    </div>
    <div id="panelBodyCollapse" class="panel-collapse collapse in">
    <div class="panel-body">
        <c:if test="${viewingDraft}">Your comments that are not finished:</c:if>
        <c:set var="commentIndex" value="${0}"/>
        <c:forEach items="${commentsForStudentsTables}" var="commentsForStudentsTable">
            <div class="panel panel-info student-record-comments${commentsForStudentsTable.extraClass}"
                 <c:if test="${empty commentsForStudentsTable.rows && (not forRecordsPage || not commentsForStudentsTable.representingSelf)}">style="display: none;"</c:if>>
                <div class="panel-heading">
                    From <b>${fn:escapeXml(commentsForStudentsTable.giverDetails)}<c:if test="${not empty courseId}"> (${courseId})</c:if></b>
                    <c:if test="${forRecordsPage && commentsForStudentsTable.representingSelf}">
                        <button type="button"
                                class="btn btn-default btn-xs icon-button pull-right"
                                id="button_add_comment"
                                onclick="showAddCommentBox();"
                                data-toggle="tooltip"
                                data-placement="top"
                                title="<%= Const.Tooltips.COMMENT_ADD %>"
                                <c:if test="${not commentsForStudentsTable.instructorAllowedToGiveComment}">disabled</c:if>>
                            <span class="glyphicon glyphicon-comment glyphicon-primary"></span>
                        </button>
                    </c:if>
                </div>
                <ul class="list-group comments"> 
                    <c:forEach items="${commentsForStudentsTable.rows}" var="commentRow">
                        <c:set var="commentIndex" value="${commentIndex + 1}" />
                        <shared:commentRow comment="${commentRow}" commentIndex="${commentIndex}" />
                    </c:forEach>
                    <c:if test="${forRecordsPage}">
                        <c:if test="${empty commentsForStudentsTable.rows && commentsForStudentsTable.representingSelf}">
                            <li class="list-group-item text-muted">
                                <i>You don't have any comments on this student.</i>
                            </li>
                        </c:if>
                        <c:set var="newCommentIndex" value="${fn:length(commentsForStudentsTable.rows) + 1}" />
                        <li class="list-group-item list-group-item-warning" id="comment_box" style="display: none;">
                            <form method="post" action="<%= Const.ActionURIs.INSTRUCTOR_STUDENT_COMMENT_ADD %>" name="form_commentadd" class="form_comment">
                                <div class="form-group form-inline">
                                    <div class="form-group text-muted">
                                        <p>
                                            Comment about ${fn:escapeXml(data.studentName)}: 
                                        </p>
                                        The default visibility for your comment is private. You may change it using the visibility options. 
                                    </div>
                                    <a id="visibility-options-trigger${newCommentIndex}" class="btn btn-sm btn-info pull-right">
                                        <span class="glyphicon glyphicon-eye-close"></span>
                                        Show Visibility Options
                                    </a>
                                </div>
                                <div id="visibility-options${newCommentIndex}" class="panel panel-default" style="display: none;">
                                    <div class="panel-heading">
                                        Visibility Options
                                    </div>
                                    <table class="table text-center" style="color: #000;">
                                        <tbody>
                                            <tr>
                                                <th class="text-center">
                                                    User/Group
                                                </th>
                                                <th class="text-center">
                                                    Can see this comment
                                                </th>
                                                <th class="text-center">
                                                    Can see comment giver's name
                                                </th>
                                                <th class="text-center">
                                                    Can see comment recipient's name
                                                </th>
                                            </tr>
                                            <tr id="recipient-person${newCommentIndex}">
                                                <td class="text-left">
                                                    <div data-toggle="tooltip" data-placement="top" title="Control what comment recipient(s) can view">
                                                        Recipient(s)
                                                    </div>
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox answerCheckbox centered" name="receiverLeaderCheckbox" type="checkbox" value="<%= CommentParticipantType.PERSON %>">
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox giverCheckbox" type="checkbox" value="<%= CommentParticipantType.PERSON %>">
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox recipientCheckbox" name="receiverFollowerCheckbox" type="checkbox" value="<%= CommentParticipantType.PERSON %>" disabled>
                                                </td>
                                            </tr>
                                            <tr id="recipient-team${newCommentIndex}">
                                                <td class="text-left">
                                                    <div data-toggle="tooltip" data-placement="top" title="Control what team members of comment recipients can view">
                                                        Recipient's Team
                                                    </div>
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox answerCheckbox" type="checkbox" value="<%= CommentParticipantType.TEAM %>">
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox giverCheckbox" type="checkbox" value="<%= CommentParticipantType.TEAM %>">
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox recipientCheckbox" type="checkbox" value="<%= CommentParticipantType.TEAM %>">
                                                </td>
                                            </tr>
                                            <tr id="recipient-section${newCommentIndex}">
                                                <td class="text-left">
                                                    <div data-toggle="tooltip" data-placement="top" title="Control what other students in the same section can view">
                                                        Recipient's Section
                                                    </div>
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox answerCheckbox" type="checkbox" value="<%= CommentParticipantType.SECTION %>">
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox giverCheckbox" type="checkbox" value="<%= CommentParticipantType.SECTION %>">
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox recipientCheckbox" type="checkbox" value="<%= CommentParticipantType.SECTION %>">
                                                </td>
                                            </tr>
                                            <tr id="recipient-course${newCommentIndex}">
                                                <td class="text-left">
                                                    <div data-toggle="tooltip" data-placement="top" title="Control what other students in this course can view">
                                                        Other students in this course
                                                    </div>
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox answerCheckbox" type="checkbox" value="<%= CommentParticipantType.COURSE %>">
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox giverCheckbox" type="checkbox" value="<%= CommentParticipantType.COURSE %>">
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox recipientCheckbox" type="checkbox" value="<%= CommentParticipantType.COURSE %>">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="text-left">
                                                    <div data-toggle="tooltip" data-placement="top" title="Control what instructors can view">
                                                        Instructors
                                                    </div>
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox answerCheckbox" type="checkbox" value="<%= CommentParticipantType.INSTRUCTOR %>">
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox giverCheckbox" type="checkbox" value="<%= CommentParticipantType.INSTRUCTOR %>">
                                                </td>
                                                <td>
                                                    <input class="visibilityCheckbox recipientCheckbox" type="checkbox" value="<%= CommentParticipantType.INSTRUCTOR %>">
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="form-group">
                                    <div id="rich-text-toolbar-comment-container"></div>
                                    <div class="panel panel-default panel-body" id="<%= Const.ParamsNames.COMMENT_TEXT %>"></div>
                                </div>
                                <div class="col-sm-offset-5">
                                    <input type="submit" class="btn btn-primary" id="button_save_comment" value="Save">
                                    <input type="button" class="btn btn-default" value="Cancel" onclick="hideAddCommentBox();">
                                    <input type="hidden" name="<%= Const.ParamsNames.COURSE_ID %>" value="${data.courseId}">
                                    <input type="hidden" name="<%= Const.ParamsNames.STUDENT_EMAIL %>" value="${data.studentEmail}">
                                    <input type="hidden" name="<%= Const.ParamsNames.RECIPIENT_TYPE %>" value="<%= CommentParticipantType.PERSON %>">
                                    <input type="hidden" name="<%= Const.ParamsNames.RECIPIENTS %>" value="${data.studentEmail}">
                                    <input type="hidden" name="<%= Const.ParamsNames.COMMENTS_SHOWCOMMENTSTO %>" value="">
                                    <input type="hidden" name="<%= Const.ParamsNames.COMMENTS_SHOWGIVERTO %>" value="">
                                    <input type="hidden" name="<%= Const.ParamsNames.COMMENTS_SHOWRECIPIENTTO %>" value="">
                                    <input type="hidden" name="<%= Const.ParamsNames.USER_ID %>" value="${data.googleId}">
                                </div>
                            </form>
                        </li>
                    </c:if>
                </ul>
            </div>
        </c:forEach>
    </div>
    </div>
</div>
