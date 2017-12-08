#pragma once

#include <sys/types.h>

//#if defined(_MSC_VER)
	//
	// Windows/Visual C++
	//
	typedef signed char             int8;
	typedef unsigned char			uint8;
	typedef signed short			int16;
	typedef unsigned short          uint16;
	typedef signed int              int32;
	typedef unsigned int            uint32;
	typedef signed long long        int64;
	typedef unsigned long long		uint64;
//#endif


#ifdef _STLP_HASH_MAP
	#define HashMap ::std::hash_map
#else
	#define HashMap ::stdext::hash_map
#endif