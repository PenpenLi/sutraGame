#include "GameRunClassManager.h"


USING_NS_CC;
using namespace cocos2d::GameClass;


GameRunClassManager* GameRunClassManager::m_instance = NULL;

GameRunClassManager::GameRunClassManager()
{

}
void GameRunClassManager::process()
{
	std::list<GameRunClass*>::iterator itr = m_list.begin();
	for (; itr != m_list.end();itr++)
	{
		GameRunClass* o = (*itr);
		if (o == NULL)
			continue;
		o->process();
		
	}
}
void GameRunClassManager::shutdown()
{
	std::list<GameRunClass*>::iterator itr = m_list.begin();
	for (; itr != m_list.end();itr++)
	{
		GameRunClass* o = (*itr);
		if (o == NULL)
			continue;
		o->shutdown();

	}
	delete this;
}

GameRunClassManager* GameRunClassManager::getInstance()
{
	if (m_instance == NULL)
		m_instance = new GameRunClassManager();

	return m_instance;
}
void GameRunClassManager::Remove(GameRunClass* obj)
{
	if (obj == NULL)
		return;
	std::list<GameRunClass*>::iterator itr = m_list.begin();
	for (; itr != m_list.end();itr++)
	{
		GameRunClass* o = (*itr);
		if (o == obj)
		{
			m_list.erase(itr);
			return;
		}
	}
}
void GameRunClassManager::add(GameRunClass* obj)
{
	if (obj == NULL)
		return;
	std::list<GameRunClass*>::iterator itr = m_list.begin();
	for (; itr != m_list.end();itr++)
	{
		GameRunClass* o = (*itr);
		if (o == obj)
			return;
	}
	m_list.push_back(obj);

}