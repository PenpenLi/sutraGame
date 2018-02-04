#ifndef GAME_RUN_CLASS_MANAGER_INCLUDE_H_
#define GAME_RUN_CLASS_MANAGER_INCLUDE_H_
#include "GameRunClass.h"
#include <list>

NS_CC_BEGIN
namespace GameClass {
	class GameRunClassManager
	{
	public:
		GameRunClassManager();
		
		void process();
		void shutdown();
		void add(GameRunClass* obj);
		void Remove(GameRunClass* obj);

		static GameRunClassManager* getInstance();
	private:
		static GameRunClassManager* m_instance;
		std::list<GameRunClass*>m_list;
	};
}

NS_CC_END

#endif