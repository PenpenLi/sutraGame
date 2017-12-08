#ifndef __WorldWarII__MacAddress
#define __WorldWarII__MacAddress

#include <iostream>

bool GetAdapterInfo(int adapterNum, std::string& macOUT);
bool GetMacByNetBIOS(std::string& macOUT);

#endif/*__WorldWarII__MacAddress*/