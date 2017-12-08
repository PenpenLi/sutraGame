//
//  SDKUtils.h
//  WorldWarII
//
//  Created by KevinChen on 14/11/16.
//
//

#ifndef __WorldWarII__SDKUtils__
#define __WorldWarII__SDKUtils__

#include "cocos2d.h"

class SDKUtils
{
public:
	SDKUtils();
	~SDKUtils();

	static SDKUtils *getInstance();
    void destroyInstance();

	void setCallbackFuncID(int init_finish_funcid,int login_success_funcid,int login_fail_funcid);

	void initFinishCallback(std::string msg,std::string partnerID);
	void loginSuccessCallback(std::string token,std::string partnerID);
	void loginFailCallback(std::string msg,std::string partnerID);
	void soundCallback(std::string msg);

	void logoutSuccessCallback();

	void initSDK();

private:
	int m_init_finish_funcid;
	int m_login_success_funcid;
	int m_login_fail_funcid;
};

#endif /* defined(__WorldWarII__SDKUtils__) */
