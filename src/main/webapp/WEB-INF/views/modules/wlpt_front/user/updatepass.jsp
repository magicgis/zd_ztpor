<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>修改密码</title>
    <link rel="stylesheet" type="text/css" href="${ctxStatic }/modules/wlpt/front/css/personal.css">
    <link rel="stylesheet" type="text/css" href="${ctxStatic }/modules/wlpt/front/css/top_menu.css">
 
    <style type="text/css">
    body{
        padding: 0;
        margin: 0;
        width: 100%;
        margin: 0 auto;
        text-align: center;
        border: 1px solid #D6D3CE;
        font-family: "微软雅黑";
    }
    #jbox{
    top: 160px;
    }
    input[type="password"],input[type="text"] {
    padding: 5px;
}
.user_infor_right {
    width: 70%;
    text-align: left;
    padding-left: 10px;
    height: 50px;
    line-height: 50px;
}
    </style>
<link href="${ctxStatic}/bootstrap/2.3.1/css_3.2cerulean/bootstrap.min.css" type="text/css" rel="stylesheet"/>


<script src="${ctxStatic }/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${ctxStatic }/common/global.js"></script>
<script type="text/javascript" src="${ctxStatic }/modules/wlpt/front/js/jquery.tips.js"></script>
<script type="text/javascript" src="${ctxStatic }/modules/wlpt/front/js/jquery.valid.js"></script>

</head>
<body>
<ul class="qiye_menu">
    <li data-type="1" class="qiye_menu_1">修改登录密码</li>
    <li data-type="2" ><a href="${wlpt }/wlpt/personal/updatecashpass" target="content" style="color: #000;">修改支付密码</a></li>
    <li data-type="3" ><a href="${wlpt }/wlpt/personal/toUpdatePasswordCard" target="content" style="color: #000;">修改一卡通密码</a></li>
</ul>

<!-- 修改登录密码 -->
<p class="user_data">
    <img src="${ctxStatic }/images/wlptfront/line-left.png"><span class="title_blue">修改</span><span
        class="title_orange">密码</span><img src="${ctxStatic}/images/wlptfront/line-right.png">
</p>
<form:form id="inputForm" modelAttribute="user" method="post" class="form-horizontal">
<form:hidden path="id"/>
<table class="user-infor">
        <tr>
            <td class="user_infor_left"><span class="star_red">*</span>手机号码:</td>
            <td class="user_infor_right">
            <form:input path="phone" id="phone" htmlEscape="false" maxlength="50" class="tel_input" cssClass="required" readonly="true" />
            <input type="button" id="sendRegCode" value="获取验证码" class="btn btn-primary countdown_time" style="margin-top: -5px;line-height: 15px;"/>
            
            </td>
        </tr>
        <tr>
            <td class="user_infor_left"><span class="star_red">*</span>短信验证码:
            </td>
            <td class="user_infor_right"><input type="text" name="regcode" id="regcode" value="" class="required"> 
            
            </td>
        </tr>
        <tr>
            <td class="user_infor_left"><span class="star_red">*</span>旧密码:</td>
            <td class="user_infor_right"><input type="password" name="oldpassword" id="oldpassword" value="" class="required"></td>
        </tr>
        <tr>
            <td class="user_infor_left"><span class="star_red">*</span>新密码:</td>
            <td class="user_infor_right"><input type="password" name="password" id="password" placeholder="" class="required"></td>
        </tr>
        <tr>
            <td class="user_infor_left"><span class="star_red">*</span>
                确认新密码:</td>
            <td class="user_infor_right"><input type="password" name="repassword" id="repassword" placeholder=""  equalTo="#password" class="required"></td>
        </tr>
        
        <tr>
            <td colspan=2>
                <button type="button" class="btn btn-defalut btn-warning" id="btn-warning">保存</button>
            </td>
        </tr>
    </table>
</form:form>


<script src="${ctxStatic }/bootstrap/2.3.1/js/bootstrap.min.js"></script>
<script src="${ctxStatic}/flash/zoom.min.js" type="text/javascript"></script>
<script src="${ctxStatic}/modules/wlpt/front/js/msgbox.js" type="text/javascript"></script>
<script type="text/javascript">

$("#sendRegCode").click(function(){
	validRegCode();
});
function validRegCode(){
		
	 $.ajax({
            cache: true,
            type: "POST",
            url: "${wlpt}/wlpt/personal/sendRegCode",
            data: {phone:$("#phone").val()},
            async: false,
            error: function (request) {
            	$.MsgBox.Alert("系统提示",'请填写正确的手机号码');
            },
            success: function (data) {
            	var message = data;
				if (message){
					sendTimeBtn($("#sendRegCode"));
				}else {
					$.MsgBox.Alert("系统提示",'请填写正确的手机号码');
				}
            }
        });
}
$("#btn-warning").click(function() {
	var isnul = true;
	isnul = isnul && $("#phone").valid(																		{
		methods : "required|isPhone"
		});
	isnul = isnul && $("#regcode").valid(																		{
		methods : "required"
		});
	if ($("#regcode").val().length != 6) {
		$("#regcode").tips({
			side : 3,
			msg : '验证码长度为6位！',
			bg : '#00A2E9',
			time : 3
		});
		return false;
	}
		isnul = isnul && $("#oldpassword").valid(																		{
			methods : "required"
			});
		isnul = isnul && $("#password").valid(																		{
			methods : "required|isPassWord"
			});
		isnul = isnul && $("#repassword").valid(																		{
			methods : "required"
			});
		if($("#password").val() != $("#repassword").val()){
			$("#repassword").tips({
				side:3,
	            msg:'输入与上面相同的密码',
	            bg:'#00A2E9',
	            time:4
	        });
			$("#repassword").focus();
			return false;
		}
		var passWord = $("#password").val();
		if (passWord.length < 6) {
			$("#password").tips({
				side : 3,
				msg : '密码长度不能小于6位！',
				bg : '#00A2E9',
				time : 3
			});
			return false;
		}
		if (passWord.length > 16) {
			$("#password").tips({
				side : 3,
				msg : '密码长度不能大于16位！',
				bg : '#00A2E9',
				time : 3
			});
			return false;
		}
	if(!isnul){
		return false;
	}
	var passWord = $("#password").val();
	if (passWord.length < 6) {
		$("#password").tips({
			side : 3,
			msg : '密码长度不能小于6位！',
			bg : '#00A2E9',
			time : 3
		});
		return false;
	}
	if (passWord.length > 16) {
		$("#password").tips({
			side : 3,
			msg : '密码长度不能大于16位！',
			bg : '#00A2E9',
			time : 3
		});
		return false;
	}
	var phone = $("#phone").val();
	var regcode =  $.trim($("#regcode").val());
	if(phone!=""||regcode!="" ){
		$.ajax({
			url : "${wlpt}/wlpt/personal/checkRegCode",
			dataType : 'json',
			type:"post",
			async:false,
			data:{phone:phone,regcode:regcode},
			success : function(data) {
				if (data == false) {
						$("#regcode").tips({
							side:3,
				            msg:'验证码有误或已过期',
				            bg:'#00A2E9',
				            time:4
				        });
						$("#regcode").focus();
						return false;
				}
				else if(data == true){
					$.MsgBox.Confirm("系统提示","确定提交吗？", function(){
						$("#btn-warning").attr('disabled','disabled'); 
						$.ajax({
			                cache: true,
			                type: "POST",
			                url: "${wlpt}/wlpt/personal/saveUpdatePass",
			                data: $('#inputForm').serialize(),// 你的formid
			                async: false,
			                error: function (request) {
								$.MsgBox.Alert("系统提示","Connection error");
			                },
			                success: function (data) {
			                	if(data.state==1){
			                		window.location.href =  "${wlpt}/logout";
			                	}
			                	$("#sendRegCode").val("获取验证码");
			                	$("#sendRegCode").removeAttr("disabled");
			                	$("#sendRegCode").css("background", "#428bca");
			                	$("#btn-warning").removeAttr("disabled");
			                	wait = 0;
			                	$.MsgBox.Alert("系统提示",data.message);
			                }
			            });
					}, null,null,null, "是", "否");
					
					
				}
			}
		});
	}
	}); 	
       

</script>
</body>
</html>