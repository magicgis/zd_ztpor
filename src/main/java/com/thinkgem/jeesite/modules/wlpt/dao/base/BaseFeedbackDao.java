/**
 * 
 */
package com.thinkgem.jeesite.modules.wlpt.dao.base;

import com.thinkgem.jeesite.common.persistence.CrudDao;
import java.util.Map;
import com.thinkgem.jeesite.common.persistence.annotation.MyBatisDao;
import com.thinkgem.jeesite.modules.wlpt.entity.base.BaseFeedback;

/**
 * 意见反馈DAO接口
 * @author 王铸
 * @version 2016-08-09
 */
@MyBatisDao
public interface BaseFeedbackDao extends CrudDao<BaseFeedback> {

	/**
	 * 批量删除
	 * @param map
	 * @return
	 */
	public void deleteAll(Map<String,String> map);
}