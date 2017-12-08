#pragma once
class AndroidUtils
{
public:
	static const char *getDeviceID();
	static const char *getDeviceModel();
	static const char *getDeviceSdk();
	static const char *getDeviceOsVersion();
	static const char *getPackageVersion();
    static const char *getSystemMacAddress();
    
	static void copyDB(const char *packFilePath ,const char * docFilePath);

	static void sdk_init();

	static void sdk_dologin();
	static void sdk_dopay(const char *payinfo);
	static void openWebView(const char *uri);
};

