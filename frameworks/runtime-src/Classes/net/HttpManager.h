//
//  HttpManager.h
//  WorldWarII
//
//  Created by KevinChen on 14/11/4.
//
//

#ifndef __WorldWarII__HttpManager__
#define __WorldWarII__HttpManager__

#include "cocos2d.h"
#include "Singleton.h"

#include "network/HttpClient.h"


class HttpManager{
public:
    HttpManager();
    ~HttpManager();
    
    static HttpManager *getInstance();
    void destroyInstance();
    
    void onHttpRequestCompleted(cocos2d::network::HttpClient *sender, cocos2d::network::HttpResponse *response);
};

#endif /* defined(__WorldWarII__HttpManager__) */
