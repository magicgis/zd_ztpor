<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <%@include  file="/WEB-INF/views/modules/wlpt_front/include/head_taget.jsp"%>
   <!--  <meta name="decorator" content="site_personal_basic"/> -->
    <title>油气兑换申请</title>
	<link href="//cdn.bootcss.com/angular-ui-grid/3.2.6/ui-grid.css" rel="stylesheet">
    <style type="text/css">
    .form-control{
			border: 1px solid #ccc !important;
		}
	.loading{
			text-align: center;
		}
        .bg_red:HOVER{
        	color: #fff;
        }
        .bg_red{
        	color: #fff;
        }
    </style>
</head>
<body style="background: #f5f5f5;">

<div style="background: #f5f5f5;" ng-app="oPublishApp" ng-controller="oPublishCtrl">
	<div class="row">
        <div class="col-lg-12" style="padding-bottom:20px;">
        	<div class="form_container">
        		<!--第一个面板-->
        		<div class="panel clearfix">
        			<h4 class="panel-heading">
        				油气兑换详情
        			</h4>
        			<div class="panel-body">
        			
	        			<div class="col-sm-12 form-horizontal">
               				<div class="col-sm-12" style="margin-top:10px;">
               					<div class="col-sm-3"></div>
               					<div class="col-sm-10 form-group">
               						<div class="col-sm-2 control-label text-right" style="">
               							兑换金额
               						</div>
               						<div class="col-sm-2 text-left">
               							<input type="text" class="form-control"  value="${petrolexchange.totalcost } 元" readonly="readonly"/>
               						</div>
               						<div class="col-sm-2 control-label text-right">
               							总条数
               						</div>
               						<div class="col-sm-2 text-left">
               							<input type="text" class="form-control"  value ="${petrolexchange.exchangeCount } 条" readonly="readonly"/>
               						</div>
               						<div class="col-sm-2 control-label text-right">
               							审核状态
               						</div>
               						<div class="col-sm-2 text-left">
               							<input type="text" class="form-control"  value ="${fns:getDictLabel(petrolexchange.status, 'exchange_status', '')}" readonly="readonly"/>
               						</div>
               					</div>
               				</div>
	        			</div>
	        			
	        			<div class="col-sm-12 form-horizontal">
             				<div id="grid1" style="height: 500px" ui-grid="gridOptions" ui-grid-auto-resize ui-grid-selection ui-grid-resize-columns class="grid"></div>
	        			</div>
	        		
	        		</div>
        		</div>
        		<div class="col-sm-12" style="margin-bottom:80px;margin-top:20px;">
                	<div class="col-sm-4"></div>
                	<div class="col-sm-4">
                		<button class="btn btn-warning col-sm-12" type="button" onclick="history.go(-1)">返  回</button>
                	</div>
                </div>
        	</div>
        </div>
    </div>
</div>

<script src="http://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
<script src="http://cdn.bootcss.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${ctxStatic }/modules/wlpt/front/js/angular/angular.min.js"></script>
<script type="text/javascript" src="${ctxStatic }/modules/wlpt/front/js/angular/angular-touch.js"></script>
<script type="text/javascript" src="${ctxStatic }/modules/wlpt/front/js/angular/angular-animate.js"></script>
<script src="/static/modules/wlpt/front/js/My97DatePicker/WdatePicker.js"></script>
<script src="${ctxStatic }/ui-grid/js/csv.js"></script>
<script src="${ctxStatic }/ui-grid/js/ui-grid.js"></script>
<script type="text/javascript" src="${ctxStatic }/modules/wlpt/front/js/jquery.tips.js"></script>
<script type="text/javascript" src="${ctxStatic }/modules/wlpt/front/js/jquery.valid.js"></script>
<script type="text/javascript" src="${ctxStatic}/modules/wlpt/front/js/jquery.pcc.js"></script>
<script type="text/javascript" src="${ctxStatic}/modules/wlpt/front/js/jquery.gridSelector.js"></script>
<script src="${ctxStatic}/modules/wlpt/front/js/msgbox.js" type="text/javascript"></script>


<script>

    $(".loading").hide();


    $.fn.serializeObject = function () {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function () {
            if (o[this.name]) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    };

    var app = angular.module('oPublishApp', ['ui.grid', 'ui.grid.selection', 'ui.grid.grouping', 'ui.grid.pagination', 'ui.grid.resizeColumns', 'ui.grid.autoResize']);
    app.controller('oPublishCtrl', ['$scope', 'i18nService', '$http', '$timeout', '$interval', 'uiGridConstants', 'uiGridGroupingConstants',
        function ($scope, i18nService, $http, $timeout, $interval, uiGridConstants, uiGridGroupingConstants) {

            
            // 国际化；
            i18nService.setCurrentLang("zh-cn");
            $scope.myData = [];
            $scope.gridOptions = {
                enableFiltering: true,
                data: 'myData'
            };
            $scope.gridOptions.rowIdentity = function (row) {
                return row.id;
            };

            $scope.gridOptions.getRowIdentity = function (row) {
                return row.id;
            };
            $scope.gridOptions.importerDataAddCallback = function (grid, newObjects) {
                if (newObjects) {
                    $scope.callsPending--;
                    newObjects.forEach(function (row) {
                        row.registered = new Date(row.registered);
                        $scope.myData.push(row);
                    });
                }
            };


            $scope.submit = function () {


                if ($scope.bgrid.selection.getSelectedRows().length <=0) {
                    $.MsgBox.Alert("提示", "请现在消费记录");
                    return false;
                }

                if ($(".loading").is(':hidden')) {
                    $(".loading").show();
                } else {
                    return false;
                }
                var inputForm = $("#inputForm").serializeObject();
                inputForm.cardRecordList=angular.toJson($scope.bgrid.selection.getSelectedRows());
                $.ajax({
                    url: '${wlpt}/wlpt/petrolexchange/petrolexchangeSave',
                    method: 'post',
                    data: inputForm
                }).success(function (response) {
                	window.location.href = '${wlpt}/wlpt/petrolexchange/myPetrolExchangeList';
                });
            };

            $scope.gridOptions.columnDefs = [
//                { name:'id',displayName:'提货单ID', width:200 },
                {name: 'billnumber', displayName: '单据号'},
                {name: 'truename', displayName: '会员姓名'},
                {name: 'recorditem.barcode', displayName: '商品编号'},
                {name: 'recorditem.gooditemname', displayName: '商品名称'},
                {name: 'recorditem.number', displayName: '商品数量'},
                {name: 'recorditem.oldprice', displayName: '商品单价'},
                {name: 'totalpaid', displayName: '实付金额'},
                
                {name: 'storename', displayName: '操作店面'},
                {name: 'useraccount', displayName: '工号'},
                {name: 'meno', displayName: '备注'},
                {name: 'operatetime', displayName: '操作时间'},
            ];

            $scope.callsPending = 0;

            $scope.refreshData = function () {
            	$scope.totalcost = 0;
                $scope.exchangeCount = 0;
                $(".loading").show();
                $scope.myData = [];
                var sec = $interval(function () {
                    $scope.callsPending++;
                    $http({
                        url: '${wlpt}/wlpt/petrolexchange/getmcrListByNo',
                        method: 'post',
                        params: {'exchangeNo': '${petrolexchange.exchangeNo}'}
                    }).success(function (data) {
                        $scope.callsPending--;
                        data.value.list.forEach(function (row) {
                            row.registered = new Date(row.registered);
                            $scope.myData.push(row);
                        });
                        $(".loading").hide();
                    });
                }, 200, 1);

                var timeout = $timeout(function () {
                    $interval.cancel(sec);
                    $scope.left = '';
                }, 2000);

                $scope.$on('$destroy', function () {
                    $timeout.cancel(timeout);
                    $interval.cancel(sec);
                });
            };
            $scope.refreshData();
        }]);

</script>


<script>


    //加法函数，用来得到精确的加法结果
    //说明：javascript的加法结果会有误差，在两个浮点数相加的时候会比较明显。这个函数返回较为精确的加法结果。
    //调用：accAdd(arg1,arg2)
    //返回值：arg1加上arg2的精确结果
    function accAdd(arg1, arg2) {
        var r1, r2, m, n;
        try {
            r1 = arg1.toString().split(".")[1].length
        } catch (e) {
            r1 = 0
        }
        try {
            r2 = arg2.toString().split(".")[1].length
        } catch (e) {
            r2 = 0
        }
        m = Math.pow(10, Math.max(r1, r2));
        n = (r1 >= r2) ? r1 : r2;
        return ((arg1 * m + arg2 * m) / m).toFixed(n);
    }


    function accSub(arg1, arg2) {
        var r1, r2, m, n;
        try {
            r1 = arg1.toString().split(".")[1].length
        } catch (e) {
            r1 = 0
        }
        try {
            r2 = arg2.toString().split(".")[1].length
        } catch (e) {
            r2 = 0
        }
        m = Math.pow(10, Math.max(r1, r2));
//last modify by deeka
//动态控制精度长度
        n = (r1 >= r2) ? r1 : r2;
        return ((arg1 * m - arg2 * m) / m).toFixed(n);
    }


</script>
</body>
</html>

