<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript" src="${ctxStatic }/common/global.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#no").focus();
			$("#inputForm").validate({
				rules: {
					loginName: {remote: "${wlpt}/wlpt/user/checkLoginName?oldLoginName=" + encodeURIComponent('${user.loginName}')},
                    phone: {
						remote: {
							url:"${wlpt}/wlpt/user/checkPhone",
							type:"post",
							data:{
								phone:function(){return $("#phone").val()}
							}
						}
					},
					/*sendRegCode:{
						remote:{
							url:"${wlpt}/wlpt/user/User/sendRegCode",
							type:"post",
							data:{
								phone:function(){return $("#phone").val()}
							}
						}
					},*/
                    validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"},
					regcode: {
						remote:{
							url:"${wlpt}/wlpt/user/checkRegCode",
							type:"post",
							data:{
								phone:function(){return $("#phone").val()},
								regcode:function(){return $("#regcode").val()}
							}
						}
					}

				},
				messages: {
					loginName: {remote: "用户登录名已存在"},
                    phone: {remote: "手机号已存在"},
                    validateCode: {remote: "验证码不正确.", required: "请填写验证码."},
					confirmNewPassword: {equalTo: "输入与上面相同的密码"},
					regcode : {remote:"验证码有误或已过期"}
				},
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});

			$("#sendRegCode").click(function(){
				validRegCode();
			});

			function validRegCode(){
				$.ajax({
					type : "POST",
					url : '${wlpt}/wlpt/user/sendRegCode',
					dataType : 'json',
					data:{phone:$("#phone").val()},
					cache : false,
					success : function(data) {
						var message = data;
						if (message){
							sendTimeBtn($("#sendRegCode"));
						}else {
							top.$.jBox.tip('请填写正确的手机号码','warning');
						}

					},
					error : function() {
						top.$.jBox.tip('请填写正确的手机号码','warning');
					}
				});
			}
		});
	</script>
</head>
<body>
<ul class="nav nav-tabs">
	<li class="active"><a>用户注册</a></li>
</ul><br/>
<form:form id="inputForm" modelAttribute="user" action="${wlpt}/wlpt/user/registerSave" method="post" class="form-horizontal">
	<form:hidden path="id"/>
	<sys:message content="${message}"/>

	<div class="control-group">
		<label class="control-label">用户角色:</label>
		<div class="controls">
				<form:radiobuttons path="role.enname" items="${fns:getDictList('userRole')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
			<span class="help-inline"><font color="red">*</font> </span>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">登录名:</label>
		<div class="controls">
			<input id="oldLoginName" name="oldLoginName" type="hidden" value="${user.loginName}">
			<form:input path="loginName" htmlEscape="false" maxlength="50" class="required userName"/>
			<span class="help-inline"><font color="red">*</font> </span>
		</div>
	</div>
    <div class="control-group">
        <label class="control-label">手机号码:</label>
        <div class="controls">
            <form:input path="phone" id="phone" htmlEscape="false" maxlength="11" cssClass="required mobile"/>
            <span class="help-inline"><font color="red">*</font> </span>
        </div>
    </div>
	<div class="control-group">
		<label class="control-label">密码:</label>
		<div class="controls">
			<input id="newPassword" name="newPassword" type="password" value="" maxlength="50" minlength="3" class="${empty user.id?'required':''}"/>
			<c:if test="${empty user.id}"><span class="help-inline"><font color="red">*</font> </span></c:if>
			<c:if test="${not empty user.id}"><span class="help-inline">若不修改密码，请留空。</span></c:if>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">确认密码:</label>
		<div class="controls">
			<input id="confirmNewPassword" name="confirmNewPassword" type="password" value="" maxlength="50" minlength="3" equalTo="#newPassword"/>
			<c:if test="${empty user.id}"><span class="help-inline"><font color="red">*</font> </span></c:if>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label mid" for="validateCode">验证码:</label>
		<div class="controls">
			<input type="text" name="regcode" id="regcode" class=""/>
			<input type="button" id="sendRegCode" value="获取验证码" class="btn btn-primary"/>
		</div>
	</div>
    <div class="control-group">
        <label class="control-label mid" for="validateCode">验证码:</label>
        <div class="controls">
            <sys:validateCode name="validateCode" inputCssStyle="margin-bottom:0;"/>
        </div>
    </div>
    <%--<div class="validateCode">
        <label class="input-label mid" >验证码</label>
        <sys:validateCode name="validateCode" inputCssStyle="margin-bottom:0;"/>
    </div>--%>
	<div class="form-actions">
        <input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
		<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
	</div>
</form:form>
</body>
</html>