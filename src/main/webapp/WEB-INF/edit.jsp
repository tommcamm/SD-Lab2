<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Bootstrap boilerplate -->
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/all.min.js"></script>
    <title>Keyboard editor</title>
</head>
<body>
    <div class="mx-4">
        <c:if test="${editMode==0}"> <h1>View a keyboard</h1> </c:if>
        <c:if test="${editMode==1}"> <h1>Edit a keyboard</h1> </c:if>

        <c:if test="${errorCode == 1}">
            <div class="alert alert-danger" role="alert">
                <h4 class="alert-heading">Something went wrong!</h4>
                <p>Request is made on an invalid keyboard id</p>
            </div>
        </c:if>
        <c:if test="${errorCode != 1}">
            <c:if test="${errorCode == 2}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <h4 class="alert-heading">Error while saving the keyboard</h4>
                    <p>Data is provided in an invalid format (blank fields for example)</p>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <form action="${pageContext.request.contextPath}/edit/${keyboard.id}" method="post" id="keyboardForm">
                <div class="row">
                    <div class="mb-3 col-1">
                        <label for="idInput" class="form-label">ID</label>
                        <input type="number" class="form-control" id="idInput" aria-describedby="emailHelp"
                               style="width: 75px" required disabled value="${keyboard.id}" name="idInput">
                    </div>
                    <div class="mb-3 col-1">
                        <label for="manufacturerInput" class="form-label">Manufacturer</label>
                        <input type="text" class="form-control" id="manufacturerInput" aria-describedby="manufacturerHelp"
                               style="width: 150px"  <c:if test="${editMode == 0}">disabled</c:if> required value="${keyboard.manufacturer}"
                               name="manufacturerInput">
                    </div>
                    <div class="mb-3 col-1">
                        <label for="colorInput" class="form-label">Switch color</label>
                        <input type="text" class="form-control" id="colorInput" aria-describedby="colorHelp"
                               style="width: 150px" <c:if test="${editMode == 0}">disabled</c:if> required value="${keyboard.switchColor}"
                               name="switchColorInput">
                    </div>
                    <div class="mb-3 col-1">
                        <label for="layoutInput" class="form-label">Layout</label>
                        <select class="form-select" aria-label="Default select example" id="layoutInput"
                                name="layoutInput" required <c:if test="${editMode == 0}">disabled</c:if> style="width: 150px">
                            <jsp:useBean id="layouts" scope="request" type="java.util.List"/>
                            <c:forEach items="${layouts}" var="layout">
                                <option <c:if test="${keyboard.layout==layout}">selected</c:if>
                                        value="${layout}"> ${layout} </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3 form-check col-1 align-items-end">
                        <input type="checkbox" class="form-check-input" id="isErgonomicInput" name="isErgonomicInput"
                               <c:if test="${keyboard.isErgonomic}">checked</c:if>
                               <c:if test="${editMode == 0}">disabled</c:if>>
                        <label class="form-check-label" for="isErgonomicInput">Ergonomic keyboard</label>
                    </div>
                    <div class="mb-3 col-1">
                        <c:forEach items="${keyboard.comments}" var="comment">
                            <em class="fas fa-arrow-right"></em> ${comment} <br/>
                        </c:forEach>
                    </div>
                </div>
                <input type="hidden" name="op" value="1"/>
            </form>

            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#commentModal">
                <em class="fas fa-plus"></em> Add a comment
            </button>
            <c:if test="${editMode==0}"><a class="btn btn-primary" href="?edit=1" role="button">
                <em class="fas fa-edit"></em> Edit the keyboard
            </a></c:if>
            <c:if test="${editMode==1}">
                <button type="button" class="btn btn-primary" id="keyboardApplyBtn">
                    <em class="fas fa-save"></em> Apply changes
                </button>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/edit/${keyboard.id}"
                   role="button"><em class="fas fa-undo"></em> Return in view mode
                </a>
            </c:if>
            <br/>
            <br/>
            <a class="btn btn-info" href="${pageContext.request.contextPath}/" role="button">
                <em class="fas fa-sign-out-alt"></em> Back in keyboard list
            </a>

            <!-- Modal -->
            <div class="modal fade" id="commentModal" tabindex="-1" aria-labelledby="commentModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="commentModalLabel">Add a comment</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form action="${pageContext.request.contextPath}/edit/${keyboard.id}" method="post" id="commentForm">
                                <div class="mb-3">
                                    <label for="commentInput" class="col-form-label">Keyboard comment:</label>
                                    <textarea class="form-control" id="commentInput" name="commentInput"></textarea>
                                </div>
                                <input type="hidden" name="op" value="0"/>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-success" id="commentSaveBtn">Save changes</button>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                $(document).ready(function() {
                    $('#commentSaveBtn').click(() =>  $('#commentForm').submit());
                    <c:if test="${editMode==1}">
                        $('#keyboardApplyBtn').click(() =>  $('#keyboardForm').submit());
                    </c:if>
                });
            </script>
        </c:if>
    </div>

</body>
</html>
