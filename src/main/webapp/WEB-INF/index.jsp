<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <title>Keyboard webapp</title>
</head>
<body>
    <div class="mx-4">
        <h1>Keyboards list</h1>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Manufacturer</th>
                    <th scope="col">Ergonomic</th>
                    <th scope="col">Switch color</th>
                    <th scope="col">Layout</th>
                    <th scope="col">Comments</th>
                </tr>
            </thead>
            <tbody>
                <jsp:useBean id="keyboards" scope="request" type="java.util.List"/>
                    <c:forEach items="${keyboards}" var="keyboard">
                        <tr>
                        <th scope="row"><a href="${pageContext.request.contextPath}/edit/${keyboard.id}">${keyboard.id}</a></th>
                        <td>${keyboard.manufacturer}</td>
                        <td>${keyboard.isErgonomic}</td>
                        <td>${keyboard.switchColor}</td>
                        <td>${keyboard.layout}</td>
                        <td>
                            <c:forEach items="${keyboard.comments}" var="comment">
                                <em class="fas fa-arrow-right"></em> ${comment} <br/>
                            </c:forEach>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addKeyboardModal">
            <em class="fas fa-plus"></em> Add a new keyboard
        </button>
    </div>

    <!-- keyboard add modal -->
    <div class="modal fade" id="addKeyboardModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Add a new keyboard</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/" method="post" id="addKeyboardForm">
                        <div class="mb-3 col-2">
                            <label for="idInput" class="form-label">ID</label>
                            <input type="number" class="form-control" id="idInput" name="idInput" value="${fn:length(keyboards)+1}" required>
                        </div>
                        <div class="mb-3">
                            <label for="manufacturerInput" class="form-label">Manufacturer</label>
                            <input type="text" class="form-control" id="manufacturerInput" name="manufacturerInput" placeholder="Aukey" required>
                        </div>
                        <div class="mb-3">
                            <label for="switchColorInput" class="form-label">Switch color</label>
                            <input type="text" class="form-control" id="switchColorInput" name="switchColorInput" placeholder="Blue" required>
                        </div>
                        <div class="mb-3">
                            <label for="layoutInput" class="form-label">Layout</label>
                            <select class="form-select" aria-label="Default select example" id="layoutInput" name="layoutInput" required>
                                <jsp:useBean id="layouts" scope="request" type="java.util.List"/>
                                <c:forEach items="${layouts}" var="layout">
                                    <option value="${layout}">${layout}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="isErgonomicInput" name="isErgonomicInput">
                            <label class="form-check-label" for="isErgonomicInput">Ergonomic keyboard</label>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="addKeyboardSubmitBtn">Save changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Toasts -->
    <div class="position-fixed bottom-0 start-0 p-3" style="z-index: 5">
        <div id="liveToast" class="toast hide" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header    ">
                <strong class="me-auto" id="toast-head-tx">Operation Successfull</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body" id="toast-body-tx">
                The operation was completed successfully.
            </div>
        </div>
    </div>

    <%-- JS (Jquery) Scripts and Flushbars --%>
    <script>
        $(document).ready(function() {
            // Submit by button in modal
            $('#addKeyboardSubmitBtn').click(() =>  $('#addKeyboardForm').submit());

            // Initialize Toasts
            let toastElList = [].slice.call(document.querySelectorAll('.toast'));
            toastElList.map(function (toastEl) {
                return new bootstrap.Toast(toastEl);
            });

            <%-- Error display management (from toast) --%>
            <c:if test="${errorCode!=null}">
                <c:choose>
                    <c:when test="${errorCode == 1}">
                        $('#toast-head-tx').html("Error while saving");
                        $('#toast-body-tx').html("provided ID format not valid");
                    </c:when>
                    <c:when test="${errorCode == 2}">
                        $('#toast-head-tx').html("Error while saving");
                        $('#toast-body-tx').html("provided data is invalid or empty!");
                    </c:when>
                    <c:when test="${errorCode == 3}">
                        $('#toast-head-tx').html("Error while saving");
                        $('#toast-body-tx').html("Selected ID is already in use");
                    </c:when>
                </c:choose>
                $('#liveToast').toast('show');
            </c:if>
            <%-- In case of success --%>
            <c:if test="${errorCode == null}">
                <c:choose>
                    <c:when test="${successCode == 1}">
                        $('#toast-head-tx').html("Success");
                        $('#toast-body-tx').html("Keyboard added successfully");
                        $('#liveToast').toast('show');
                    </c:when>
                </c:choose>
            </c:if>
        });
    </script>

</body>
</html>