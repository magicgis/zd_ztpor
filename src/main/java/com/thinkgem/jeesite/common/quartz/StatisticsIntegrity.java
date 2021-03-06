package com.thinkgem.jeesite.common.quartz;

import com.thinkgem.jeesite.common.utils.Const;
import com.thinkgem.jeesite.common.utils.LogStackTrace;
import com.thinkgem.jeesite.common.utils.ServiceHelper;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.wlpt.biz.IntegrityBiz.IntegrityBiz;
import com.thinkgem.jeesite.modules.wlpt.entity.base.BaseJoblog;
import com.thinkgem.jeesite.modules.wlpt.entity.base.BscJob;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import java.util.List;

/**
 * 统计诚信
 *
 * @author 曾煜佳
 */
public class StatisticsIntegrity extends BaseQuartzJobBean {

    IntegrityBiz integrityBiz = ServiceHelper.getIntegrityBiz();


    protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
        BscJob bscJob = new BscJob();
        BaseJoblog baseJoblog = new BaseJoblog();
        Boolean isLog = true;
        try {
            bscJob.setJobcode(Const.Job_Code.STATISTICS_INTEGRITY.name());
            bscJob = jobBiz.findByCondition(bscJob);
            baseJoblog.setJobid(bscJob.getId());
            isLog = bscJob.getIslog().equals("1");
            acquStart(bscJob, baseJoblog, isLog);
        } catch (Exception ex) {
            try {
                baseJoblog.setExceptioninfo(LogStackTrace.getLogStackTraceInfo(ex));
                if (isLog) {
                    baseJobLogBiz.save(baseJoblog);
                }
            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    private void acquStart(BscJob pdJobLog, BaseJoblog baseJoblog, Boolean isLog) throws Exception {
        if (isLog) {
            baseJobLogBiz.save(baseJoblog);
        }

        List<User> loginUsers = integrityBiz.getLoginUsers();
        for (User user : loginUsers) {
            integrityBiz.updateUserMemberLevel(user);
            
        }


    }
}
