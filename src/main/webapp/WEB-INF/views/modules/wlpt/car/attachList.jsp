<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>绑定司机管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/wlpt/car/attach/">绑定司机列表</a></li>
		<shiro:hasPermission name="wlpt:car:attach:edit"><li><a href="${ctx}/wlpt/car/attach/form">绑定司机添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="attach" action="${ctx}/wlpt/car/attach/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>主账户ID）：</label>
				<sys:treeselect id="user" name="user.id" value="${attach.user.id}" labelName="user.name" labelValue="${attach.user.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>关系用户ID：</label>
				<sys:treeselect id="reuser" name="reuser.idlname" value="${attach.reuser.idlname}" labelName="" labelValue="${attach.reuser.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>车辆ID：</label>
				<form:input path="carId" htmlEscape="false" maxlength="32" class="input-medium"/>
			</li>
			<li><label>是否同意：</label>
				<form:input path="isagree" htmlEscape="false" maxlength="2" class="input-medium"/>
			</li>
			<li><label>是否删除：</label>
				<form:radiobuttons path="delFlag" items="${fns:getDictList('del_flag')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			</li>
			<li><label>创建时间：</label>
				<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${attach.beginCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
				<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${attach.endCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>
			<li><label>更新时间：</label>
				<input name="beginUpdateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${attach.beginUpdateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
				<input name="endUpdateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${attach.endUpdateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>
			<li><label>创建者：</label>
				<form:input path="createBy.id" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li><label>更新者：</label>
				<form:input path="updateBy.id" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li><label>remarks：</label>
				<form:input path="remarks" htmlEscape="false" maxlength="255" class="input-medium"/>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>主账户ID）</th>
				<th>关系用户ID</th>
				<th>车辆ID</th>
				<th>是否同意</th>
				<th>是否删除</th>
				<th>创建时间</th>
				<th>更新时间</th>
				<th>创建者</th>
				<th>更新者</th>
				<th>remarks</th>
				<shiro:hasPermission name="wlpt:car:attach:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="attach">
			<tr>
				<td><a href="${ctx}/wlpt/car/attach/form?id=${attach.id}">
					${attach.user.name}
				</a></td>
				<td>
					${attach.reuser.name}
				</td>
				<td>
					${attach.carId}
				</td>
				<td>
					${attach.isagree}
				</td>
				<td>
					${fns:getDictLabel(attach.delFlag, 'del_flag', '')}
				</td>
				<td>
					<fmt:formatDate value="${attach.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					<fmt:formatDate value="${attach.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${attach.createBy.name}
				</td>
				<td>
					${attach.updateBy.name}
				</td>
				<td>
					${attach.remarks}
				</td>
				<shiro:hasPermission name="wlpt:car:attach:edit"><td>
    				<a href="${ctx}/wlpt/car/attach/form?id=${attach.id}">修改</a>
					<a href="${ctx}/wlpt/car/attach/delete?id=${attach.id}" onclick="return confirmx('确认要删除该绑定司机吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>