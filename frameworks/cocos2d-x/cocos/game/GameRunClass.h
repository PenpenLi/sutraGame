#ifndef GAME_RUN_CLASS_INCLUDE_H_
#define GAME_RUN_CLASS_INCLUDE_H_

#include "platform/CCPlatformMacros.h"

NS_CC_BEGIN

namespace GameClass {

	class GameRunClass
	{
	public:
		virtual ~GameRunClass(){}
		virtual void process() = 0;
		virtual void shutdown() = 0;
	};
}



NS_CC_END

#endif //__CCHTTPREQUEST_H__
