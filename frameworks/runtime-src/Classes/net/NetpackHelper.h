//
//  NetpackHelper.h
//  Talua
//
//  Created by KevinChen on 14-6-17.
//
//

#ifndef __Talua__NetpackHelper__
#define __Talua__NetpackHelper__

#include <iostream>
#include <unordered_map>

#include "cocos2d.h"
#include "./ByteBuffer.h"

#include "json/document.h"
//#include "LuaScriptHandlerMgr.h"
#include "CCLuaStack.h"
#include "CCLuaEngine.h"

//dict, pack, key, typeStr, v["arraytype"].GetString(), NULL, 0
typedef void (*FP)(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);



//LuaValueArray& lArray,const char *typeStr,ByteBuffer *pack


class NetpackHelper {
public:
//    static const unsigned char *converToBuf(const char *jsonStr);

    static ByteBuffer converToByteBuf(const char *jsonStr);
    static std::string bufToJsonString(const char *buf,int buflen);

	static cocos2d::LuaValueDict bufToLuaValue(const char *buf,int buflen);

	static void init();
    
private:
	
	static std::unordered_map<std::string, FP> htmap;
	static std::unordered_map<std::string, int> typeMap;
	static std::unordered_map<std::string, rapidjson::Document *> objMap;

	static FP fp_array;
	static FP fp_object;
	static FP fp_string;
	static FP fp_long;
	static FP fp_int;
	static FP fp_short;
	static FP fp_float;
	static FP fp_double;
	static FP fp_byte;
	static FP fp_boolean;

	static FP fp_object_arr;
	static FP fp_string_arr;
	static FP fp_long_arr;
	static FP fp_int_arr;
	static FP fp_short_arr;
	static FP fp_float_arr;
	static FP fp_double_arr;
	static FP fp_byte_arr;
	static FP fp_boolean_arr;


	/*static void (*fp_array)(LuaValueDict dict, ByteBuffer *pack, const char *key, const char *arrayType);
	static void (*fp_object)(LuaValueDict dict, ByteBuffer *pack, const char *key, const char *typeStr);
	static void (*fp_string)(LuaValueDict dict, ByteBuffer *pack, const char *key);
	static void (*fp_long)(LuaValueDict dict, ByteBuffer *pack, const char *key);
	static void (*fp_int)(LuaValueDict dict, ByteBuffer *pack, const char *key);
	static void (*fp_short)(LuaValueDict dict, ByteBuffer *pack, const char *key);
	static void (*fp_float)(LuaValueDict dict, ByteBuffer *pack, const char *key);
	static void (*fp_double)(LuaValueDict dict, ByteBuffer *pack, const char *key);
	static void (*fp_byte)(LuaValueDict dict, ByteBuffer *pack, const char *key);
	static void (*fp_boolean)(LuaValueDict dict, ByteBuffer *pack, const char *key);*/

    static bool isObject(const char *typeStr);
    static bool isArray(const char *typeStr);
    
    static void appendStr(std::string& source,const std::string& str);
    static void appendStrWithFormat(std::string& source,const char* format, ...);
    
    static std::string createStrWithFormat(const char* format, ...);
    static std::string getValueString(const char *key,const char *typeStr,ByteBuffer *pack);
	static std::string getValueStringForArray(const char *typeStr,ByteBuffer *pack);
    static std::string getObjectString(ByteBuffer *pack,const char*objectName,bool checkEmpty = true);
    static std::string getObjectString(ByteBuffer *pack,const char*objectName,int packtype,int packindex,bool checkEmpty = true);

	static std::string getJsonFilePath(const char* objectName);

	static cocos2d::LuaValueDict converBufToLuaDict(ByteBuffer *pack,const char *objectName);
	
	static void addValueToLuaDictByType(cocos2d::LuaValueDict& dict,const char *typeStr,ByteBuffer *pack,const char *key);
	static void addValueToLuaArrayByType (cocos2d::LuaValueArray& lArray,const char *typeStr,ByteBuffer *pack);

	static void decodeArray(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeObject(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeString(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeLong(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeInt(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeShort(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeByte(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeBoolean(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeFloat(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeDouble(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	
	static void decodeObjectArr(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeStringArr(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeLongArr(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeIntArr(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeShortArr(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeByteArr(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeBooleanArr(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeFloatArr(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);
	static void decodeDoubleArr(cocos2d::LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, cocos2d::LuaValueArray& tmpArray, int arraylen);

	static bool isExistsType(std::string);

};

#endif /* defined(__Talua__NetpackHelper__) */