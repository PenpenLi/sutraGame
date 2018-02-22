
#ifndef __IOSAPPHELPER_H__
#define __IOSAPPHELPER_H__


class IosAppHelper
{
public:
    static IosAppHelper* instance();
public:
    IosAppHelper();
    
    
    const char* GetImsiIni();
    
    void initSDK();
};

#endif
