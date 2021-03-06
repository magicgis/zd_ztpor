//package com.thinkgem.jeesite.modules.weixin.service;
//
//import java.util.Map;
//
//import net.sf.json.JSONObject;
//
//import org.apache.http.util.TextUtils;
//import org.apache.log4j.Logger;
//import com.thinkgem.jeesite.modules.weixin.entity.template.Message;
//import com.thinkgem.jeesite.modules.weixin.entity.template.TemplateData;
//import com.thinkgem.jeesite.modules.weixin.entity.template.TemplateMsg;
//import com.thinkgem.jeesite.modules.weixin.utils.WeixinUtil;
//
///*import cn.com.hexway.service.system.user.UserService;
//import cn.com.hexway.util.ServiceHelper;*/
//
//public class TemplateService {
//
//	public static Logger log = Logger.getLogger(TemplateService.class);
//	/*private static UserService userService = ServiceHelper.getUserService();*/
//	
//	/**
//	 * 发送模板消息接口
//	 * @param args
//	 */
//	public static String SEND_TEMPLATE_MSG_URL = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=ACCESS_TOKEN";
//	
//	/**
//	 * 发送模板消息
//	 * @param userID	用户ID
//	 * @param templateID	模板消息ID
//	 * @param msgUrl	消息链接，如无则为""
//	 * @param dataMap	消息数据Map
//	 */
//	public static void sendWXTempMessage(String OpenID, String templateID, String msgUrl, Map<String, String> dataMap) {
//		try {
//			if (TextUtils.isEmpty(OpenID)) {	// openID为空代表用户未绑定微信，不发送消息
//				return;
//			} else {
//				String firstData = (null == dataMap.get("first")) ? "" : dataMap.get("first");
//				String keyword1Data = (null == dataMap.get("keyword1")) ? null : dataMap.get("keyword1");
//				String keyword2Data = (null == dataMap.get("keyword2")) ? null : dataMap.get("keyword2");
//				String keyword3Data = (null == dataMap.get("keyword3")) ? null : dataMap.get("keyword3");
//				String keyword4Data = (null == dataMap.get("keyword4")) ? null : dataMap.get("keyword4");
//				String keyword5Data = (null == dataMap.get("keyword5")) ? null : dataMap.get("keyword5");
//				String remarkData = (null == dataMap.get("remark")) ? null : dataMap.get("remark");
//				
//				Message first = new Message(firstData, "#0000ff");
//				Message keyword1 = new Message(keyword1Data, "");
//				Message keyword2 = new Message(keyword2Data, "");
//				Message keyword3 = new Message(keyword3Data, "");
//				Message keyword4 = new Message(keyword4Data, "");
//				Message keyword5 = new Message(keyword5Data, "");
//				Message remark = new Message(remarkData, "");
//				
//				Object object = new TemplateData(first, keyword1, keyword2, keyword3, keyword4, keyword5, remark);
//				
//				sendMessage(OpenID, templateID,msgUrl, object);
//			}
//		} catch (Exception e) {
//			log.error(e);
//		}
//	}
//	
//	/**
//	 * 发送模板消息
//	 * @param userID	用户ID
//	 * @param templateID	模板消息ID
//	 * @param msgUrl	消息链接，如无则为""
//	 * @param dataMap	消息数据Map
//	 */
//	public static void sendTempMessage(String userID, String templateID, String msgUrl, Map<String, String> dataMap) {
///*		PageData pd = new PageData();
//		pd.put("userID", userID);
//		try {
//			pd = userService.findByCondition(pd);
//			if (null == pd) {
//				return;
//			}
//			String openID = pd.getString("OpenID");
//			if (TextUtils.isEmpty(openID)) {	// openID为空代表用户未绑定微信，不发送消息
//				return;
//			} else {
//				String firstData = (null == dataMap.get("first")) ? "" : dataMap.get("first");
//				String keyword1Data = (null == dataMap.get("keyword1")) ? null : dataMap.get("keyword1");
//				String keyword2Data = (null == dataMap.get("keyword2")) ? null : dataMap.get("keyword2");
//				String keyword3Data = (null == dataMap.get("keyword3")) ? null : dataMap.get("keyword3");
//				String keyword4Data = (null == dataMap.get("keyword4")) ? null : dataMap.get("keyword4");
//				String keyword5Data = (null == dataMap.get("keyword5")) ? null : dataMap.get("keyword5");
//				String remarkData = (null == dataMap.get("remark")) ? null : dataMap.get("remark");
//				
//				Message first = new Message(firstData, "#0000ff");
//				Message keyword1 = new Message(keyword1Data, "");
//				Message keyword2 = new Message(keyword2Data, "");
//				Message keyword3 = new Message(keyword3Data, "");
//				Message keyword4 = new Message(keyword4Data, "");
//				Message keyword5 = new Message(keyword5Data, "");
//				Message remark = new Message(remarkData, "");
//				
//				Object object = new TemplateData(first, keyword1, keyword2, keyword3, keyword4, keyword5, remark);
//				
//				sendMessage(openID, templateID,msgUrl, object);
//			}
//		} catch (Exception e) {
//			log.error(e);
//		}*/
//	}
//
//	/**
//	 * 
//	 * @param toUser	消息接收者Open_ID 
//	 * @param templateID	模板ID
//	 * @param msgUrl	消息打开链接
//	 * @param msgData	消息内容
//	 */
//	private static void sendMessage(String toUser, String templateID, String msgUrl, Object msgData) {
//		TemplateMsg tempMsg = new TemplateMsg();
//		tempMsg.setTouser(toUser);	// 接收消息用户openID
//		tempMsg.setData(msgData);	// 消息数据
//		tempMsg.setUrl(msgUrl);	// 模板消息链接
//		tempMsg.setTopcolor("#00ff00");	// 消息头颜色
//		tempMsg.setTemplate_id(templateID);	// 模板ID
//		String msg = JSONObject.fromObject(tempMsg).toString();
//		String token = WeixinUtil.getToken();
//		if (!TextUtils.isEmpty(token)) {
//			// 拼接发送模板消息url
//			String url = SEND_TEMPLATE_MSG_URL.replace("ACCESS_TOKEN", token);
//			// 调用接口发送消息
//			JSONObject jsonObject = WeixinUtil.httpsRequest(url, "POST", msg);
//			if (null != jsonObject) {	
//				if (0 != jsonObject.getInt("errcode")) {
//					System.out.println("-----------------------------errcode"+jsonObject.getInt("errcode")+jsonObject.getString("errmsg"));
//					log.error("发送模板消息失败errcode:" + jsonObject.getInt("errcode") + "，errmsg:" + jsonObject.getString("errmsg"));
//				} else {
//					log.debug("发送模板消息成功！");
//					System.out.println("----------------------success");
//				}
//			}
//		}
//	}
//
//}
