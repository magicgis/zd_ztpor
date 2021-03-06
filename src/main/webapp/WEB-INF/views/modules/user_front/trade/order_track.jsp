<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
<%--
    <meta name="decorator" content="site_personal_basic"/>
--%>

    <title>运输监控</title>

    <style type="text/css">
        em {
            font-style: normal;
            font-weight: 700;
            font-family: sans-serif;
        }

        .tracktab td {
            height: 20px;
            margin: 0px;
            padding: 0px;
        }

        .ratings li {
            height: 40px;
            line-height: 40px;
        }

        .lift li {
            float: left;
            margin-right: 15px;
        }

        input[type='button'] {
            display: inline-block;
            font-size: 10px;
            background-color: white;
            border: solid 1px #CCC;
        }



        .ct_lf div {
            float: left;
            margin-right: 5px;
            line-height: 30px;
            display: table-cell;
            vertical-align: middle;
            display: table-cell;
            font-size: 16px;
        }


        .ic_img img {
            width: 25px;
            display: table-cell;
            vertical-align: middle;
            display: table-cell;
        }



        .cb_val div {
            float: left;
            word-wrap: break-word;
        }

        .img_text img {
            width: 60px;
            height: 60px;
        }


        .timeline-content p {
            width: 100%;
            border-top: 1px solid #CCC;
            padding-top: 5px;
        }

        h2 {
            font-size: 18px;
        }

        #timeline .timeline-item .timeline-content h2 {
            padding: 10px;
        }

        .sub-reListOrder table {
            width: 90%;
            border: 1px solid #000;
            font-size: 12px;
            margin: 20px auto;
        }

        .sub-reListOrder table td {
            width: 9%;
            border: 1px solid #000;
            text-align: center;
            height: 20px;
            color: #000;
            font-size: 14px;
        }

        .sub-reListOrder table td div {
            color: #000;
            font-size: 14px;
        }



    </style>
</head>
<body scroll="no" style=" width: 100%;margin: 0 auto;">
<input type="hidden" id="ISLBS" value="${islbs }"/>
<div style="width:100%;height: 400px;" id="locationmap"></div>
<c:if test="${islbs != 'true' }">
<div id="guijiShow" style='text-align: center;margin-top: 20px'>
    <button class="btn btn-defalut btn-warning" id="btn-warning">开始轨迹回放</button>
</div>
</c:if>

<script src="${ctxStatic }/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
<script type="text/javascript"
        src="http://api.map.baidu.com/api?v=2.0&ak=80f73f31cfbb40be26acda67af03da43"></script>
<script type="text/javascript"
        src="http://api.map.baidu.com/library/LuShu/1.2/src/LuShu_min.js"></script>
<script>
var map = new BMap.Map("locationmap", {
    minZoom: 4,
    maxZoom: 20
}); // 创建Map实例
map.setCurrentCity("邯郸"); // 设置地图显示的城市 此项是必须设置的
map.enableScrollWheelZoom(true); //开启鼠标滚轮缩放
//map.centerAndZoom("邯郸",13);         ///当前地方与等级
map.centerAndZoom("邯郸", 10);

//小图标
var myIcon = new BMap.Icon(
        "${ctxStatic }/images/car.png",
        new BMap.Size(25, 25));




var p1;
var p2;
var poline = [];
if ($("#ISLBS").val() == "true") {
    searchLocation(1);
}else{
	loadMap();
}
function searchLocation(curPageNo) {
    var datainfo = {
        orderNo: "${orderinfo.orderno}"
    };
    $.ajax({
        url: "${wlpt}/wlpt/lbsinfo/getlocation",
        type: "POST",
        data: datainfo,
        async: false,
        success: function (data) {
            $("input[name=loctPhone]").val(data.localphone);
            if (data.state==1) {
            	var list = data.data.list;
                var html = "";
                /* $("#licont").nextAll().remove(); */

                for (var i = 0; i < list.length; i++) {
                    /* html += fillOneData(list[i]); */
                    ///定位的位置是有偏差的所以进行了移动
                    p2 = new BMap.Point(
                            list[list.length - 1].lng,
                            list[list.length - 1].lat);
                    p1 = new BMap.Point(list[0].lng,
                            list[0].lat);
                    var firstpoint = new BMap.Point(
                            list[list.length - 1].lng,
                            list[list.length - 1].lat);
                    map.centerAndZoom(firstpoint, 10); // 初始化地图,设置中心点坐标和地图级别
                    var point = new BMap.Point(
                            list[i].lng,
                            list[i].lat);
                    poline.push(new BMap.Point(
                            list[i].lng,
                            list[i].lat));//折线
                    addMarker(point,
                            list[i].createtime, i,
                            list.length);
                }
                //当没有数据的时候以邯郸为中心
                if (list.length <= 0) {
                    map.centerAndZoom("邯郸", 10); // 初始化地图,设置中心点坐标和地图级别
                }
                /* $("#ltcont li").first().nextAll().remove();
                $("#ltcont li").first().css("display", "none");
                $("#licont").after(html);
                $("#allcount").html(data.allcount);
                $("#pageCount").html(data.pageCount);
                $("#curPage").html(data.curPage); */
            } else {
                /* $("#ltcont li").first().css("display", "none"); */
                map.centerAndZoom("邯郸", 10); // 初始化地图,设置中心点坐标和地图级别
            }
        },
        error: function () {
            map.centerAndZoom("邯郸", 10); // 初始化地图,设置中心点坐标和地图级别
        }
    });
    var polyline = new BMap.Polyline(poline, {
        strokeColor: "blue",
        strokeWeight: 2,
        strokeOpacity: 0.5
    }); //创建折线
    // 编写自定义函数,创建标注
    function addMarker(point, info, curindex, maxindex) {
        var marker = new BMap.Marker(point);
        var opts = {
            position: point, // 指定文本标注所在的地理位置
            offset: new BMap.Size(20, -20)
            //设置文本偏移量
        };
        var label = new BMap.Label(info, opts); // 创建文本标注对象
        label.setStyle({
            color: "blue",
            fontSize: "12px",
            height: "20px",
            lineHeight: "20px",
            fontFamily: "微软雅黑"
        });
        marker.setLabel(label);
        map.addOverlay(marker);
        /* if(curindex==0||curindex>=maxindex){
         marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳动的动画
         var marker2 = new BMap.Marker(point,{icon:myIcon});  // 创建标注
         map.addOverlay(marker2);              // 将标注添加到地图中
         //map.addOverlay(polyline);   //增加折线
         } */
    }

    var driving = new BMap.DrivingRoute(map, {
        renderOptions: {
            map: map,
            autoViewport: true
        }
    });
    driving.search(p1, p2, {
        waypoints: poline
    });//waypoints表示途经点
}

/* function fillOneData(data) {
    var html = $("#ltcont").html();
    for (var key in data) {
        var val = data[key];
        html = html.replace("{{" + key + "}}", val);
        if (key == "ADDRESS") {
            var ads = val.substring(0, 20) + "...";
            html = html.replace("{{ADDRESS}}", ads);
            $("#ltcont li").first().css("display", "block");
        }
    }
    return html;
} */


    
    function loadMap() {
	$.MsgBox.Confirm("系统提示", "平台运输轨迹包含收费服务，使用将收取服务费用<a style='color:red'>${fns:getMsgLabel('zjxl006','zjxl_port','')}元</a>，请仔细阅读<a target='_blank' onclick='openagreement(&quot;LocationService&quot;)' style='line-height: 30px;text-decoration: none;'>《平台定位增值服务协议》</a>，是否使用？", function () {
        var btime = "${start}";
        var etime = "${end}";
        if (btime != "" && btime != null) {
            //btime = btime.replace(new RegExp("-", "gm"), "/");
        } else {
            btime = (new Date()).getTime(); //得到毫秒数
        }
       // btime = (new Date(btime)).getTime(); //得到毫秒数
        if ("${orderinfo.orderstatus}" ==5) {
           // etime = etime.replace(new RegExp("-", "gm"), "/");
         //   etime = (new Date(btime)).getTime(); //得到毫秒数
        } else {
            etime = (new Date()).getTime(); //得到毫秒数
        }
        var data = {};
        data.version = 1;
        data.method = 'loadHistory';
        data.vid = "${gpsCar.cid}";
        data.vKey = "${gpsCar.ckey}";
        data.bTime = btime;
        data.eTime = etime;
        $.ajax({
            type: "get",
            url: "http://219.148.85.56:89/gpsonline/GPSAPI",
            data: data,
            dataType: "json",
            success: function (data) {
                if (data.history && data.history.length > 0) {
                    //设置地图中心点
                    var lng = data.history[0].lng
                            + data.history[0].lng_xz;
                    var lat = data.history[0].lat
                            + data.history[0].lat_xz;

                    var arrPois = [];
                    for (var i = 0; i < data.history.length; i++) {
                        var x = data.history[i].lng
                                + data.history[i].lng_xz;
                        var y = data.history[i].lat
                                + data.history[i].lat_xz;
                        arrPois[i] = new BMap.Point(x, y);
                    }

                    map.addOverlay(new BMap.Polyline(arrPois, {
                        strokeColor: '#111'
                    }));
                    var arrStartEnd = [];
                    arrStartEnd[0] = arrPois[0];
                    arrStartEnd[1] = arrPois[1];
                    //map.setViewport(arrStartEnd);
                    map.centerAndZoom(new BMap.Point(lng, lat),
                            14);
                    var lushu = new BMapLib.LuShu(
                            map,
                            arrPois,
                            {
                                defaultContent: "",
                                autoView: true,
                                icon: new BMap.Icon(
                                        '${ctxStatic }/images/cc.png',
                                        new BMap.Size(25, 30),
                                        {
                                            /* anchor: new BMap.Size(
                                                    27, 13) */
                                        }),
                                speed: 4500,
                                enableRotation: false,//是否设置marker随着道路的走向进行旋转
                                landmarkPois: []
                            });
                    lushu.start();

                    $("btn-warning").onclick = function () {
                        lushu.start();
                    };
                    $("stop").onclick = function () {
                        lushu.stop();
                    };
                    $("pause").onclick = function () {
                        lushu.pause();
                    };
                    $("pause").hide();
                    $("hide").onclick = function () {
                        lushu.hideInfoWindow();
                    };
                    $("show").onclick = function () {
                        lushu.showInfoWindow();
                    };
                    $("show").hide();
                    function $(element) {
                        return document.getElementById(element);
                    }
                }

            }
        });
	 }, function () {
     	 $("#maskloading", parent.document).hide();
      }, "是", "否");  
        
    }

</script>
</body>
</html>
