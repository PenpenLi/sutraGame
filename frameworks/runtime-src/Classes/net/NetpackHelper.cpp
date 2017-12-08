//
//  NetpackHelper.cpp
//  Talua
//
//  Created by KevinChen on 14-6-17.
//
//
#include "NetpackHelper.h"


//#include "ByteBuffer.h"

#include "json/document.h"
#include "json/filestream.h"
#include "json/prettywriter.h"
#include "json/stringbuffer.h"

USING_NS_CC;

using namespace rapidjson;

FP NetpackHelper::fp_array = 0;
FP NetpackHelper::fp_object = 0;
FP NetpackHelper::fp_string = 0;
FP NetpackHelper::fp_long = 0;
FP NetpackHelper::fp_int = 0;
FP NetpackHelper::fp_short = 0;
FP NetpackHelper::fp_float = 0;
FP NetpackHelper::fp_double = 0;
FP NetpackHelper::fp_byte = 0;
FP NetpackHelper::fp_boolean = 0;

FP NetpackHelper::fp_object_arr = 0;
FP NetpackHelper::fp_string_arr = 0;
FP NetpackHelper::fp_long_arr = 0;
FP NetpackHelper::fp_int_arr = 0;
FP NetpackHelper::fp_short_arr = 0;
FP NetpackHelper::fp_float_arr = 0;
FP NetpackHelper::fp_double_arr = 0;
FP NetpackHelper::fp_byte_arr = 0;
FP NetpackHelper::fp_boolean_arr = 0;

std::unordered_map<std::string, FP> NetpackHelper::htmap;
std::unordered_map<std::string, int> NetpackHelper::typeMap;
std::unordered_map<std::string, rapidjson::Document *> NetpackHelper::objMap;

//const unsigned char* NetpackHelper::converToBuf(const char *jsonStr)
//{
//    ByteBuffer buf;
//    
//    //解析json对象
//    
//    rapidjson::Document d;
//    d.Parse<0>(jsonStr);
//    
//    if (d.HasParseError()) {
//        CCLOG("解析Json对象出错");
//        return NULL;
//    }
//    
//    if (!d.IsArray()) {
//        //需要json对象是数组
//        for (int i = 0; i < d.Size(); i++) {
//            rapidjson::Value &v = d[i];
//            
//            if (v.IsString()) {
//                buf << v.GetString();
//            }else if (v.IsInt()){
//                buf << v.GetInt();
//            }else if (v.IsInt64()){
//                buf << v.GetInt64();
//            }
//        }
//        CCLOG("返回对象");
//        return buf.contents();
//    }else{
//        CCLOG("根数据不是数组");
//        return NULL;
//    }
//    
//    
//    return NULL;
//}

ByteBuffer NetpackHelper::converToByteBuf(const char *jsonStr)
{
    ByteBuffer buf;
    
    //解析json对象
    
    rapidjson::Document d;
    d.Parse<0>(jsonStr);
    
    if (d.HasParseError()) {
        //CCLOG("解析Json对象出错");
        return NULL;
    }
    
    if (d.IsArray()) {
        //需要json对象是数组
        int head = 0;
        buf << head;  //包头
        
		for (unsigned int i = 0; i < d.Size(); i++) {
            rapidjson::Value &v = d[i];
            
            const char *type = v["type"].GetString();
            rapidjson::Value &value = v["value"];
            
            /*
             int8 _byte;
             int8 _boolean;
             int16 _short;
             int _int;
             float _float;
             double _double;
             uint64 _long;
             std::string _string;
             */
            
            if (strcmp(type, "string")==0) {
                buf << value.GetString();
            }else if (strcmp(type, "int")==0){
                buf << (int32)(value.GetInt());
            }else if (strcmp(type, "long")==0){
                buf << (int64)(value.GetInt64());
            }else if (strcmp(type, "short")==0){
                buf << (int16)(value.GetInt());
            }else if (strcmp(type, "bool")==0){
                buf << (int8)(value.GetBool());
            }else if (strcmp(type, "byte")==0){
                buf << (int8)(value.GetInt());
            }else if (strcmp(type, "double")==0){
                buf << (double)(value.GetDouble());
            }else if (strcmp(type, "float")==0){
                buf << (float)(value.GetDouble());
            }
        }
        
        int packlen = (int)(buf.size() - 4);
        
        buf.put(0, packlen); //包头
        
        //CCLOG("返回对象，长度:%ld",buf.size());
        return buf;
    }else{
        //CCLOG("根数据不是数组");
        return NULL;
    }
    
    
    return NULL;
}

std::string NetpackHelper::bufToJsonString(const char *buf,int buflen)
{
	//return "{\"_packtype\":\"180001\",\"_packindex\":\"101\",\"key\":\"我是中文\"}";
    //使用json配置来解析包
    ByteBuffer pack;
    pack.append(buf,buflen);
    
    int packtype;
    int packindex;
    pack >> packtype;
    pack >> packindex;
    
    
    //CCLOG("收到包，类型为:%d,包号为:%d",packtype,packindex);
    
    //根据包类型找到解析模版
    //    char filename[64];
    //    sprintf(filename,"res/response/%d.json",packtype);
    //
    //    std::string fileStr = FileUtils::getInstance()->getStringFromFile(filename);
    //
    //    if (fileStr == "") {
    //        return NULL;
    //    }
    
    
    std::string sPackType = createStrWithFormat("%d",packtype);
    
    std::string output = getObjectString(&pack, sPackType.c_str(),packtype,packindex,false);
    
    return output;
    
    
    //    __String *sPackType = __String::createWithFormat("%d",packtype);
    //    const char *output = getObjectString(&pack, sPackType->getCString(),packtype,packindex,false);
    //    return output;
    
    //    //CCLOG("%s",output);
    
    //    Document d; //用于解析模版
    //    d.Parse<0>(fileStr.c_str());
    //
    //
    //    __String *outputJson = __String::create("{");
    //
    //    if (d.HasParseError() || !d.IsArray()) {
    //        //CCLOG("解析JSON对象错误");
    //        return NULL;
    //    }
    //
    //    for (int i = 0; i < d.Size(); ++i) {
    //        rapidjson::Value &v = d[i];
    //
    //        const char *key = v["k"].GetString();
    //        const char *typeStr = v["t"].GetString();
    //
    //        if (isObject(typeStr)) {
    //            //是对象
    //        }else if (isArray(typeStr)){
    //            //是数组
    //            const char *arrayType = v["arraytype"].GetString();
    //            if (isObject(arrayType)) {
    //
    //            }
    //
    //        }else{
    //            putValue(key, typeStr, &pack, outputJson);
    //        }
    //
    //        if (i < d.Size()-1) {
    //            outputJson->append(",");
    //        }
    //    }
    //
    //    outputJson->append("}");
    //
    //    //CCLOG("%s",outputJson->getCString());
    
    
    
    /*
     rapidjson::Document output;    //用于输出
     output.SetObject();
     rapidjson::Document::AllocatorType& allocator = output.GetAllocator();
     
     output.AddMember("_packtype", packtype, allocator);
     output.AddMember("_packindex", packindex, allocator);
     
     if (d.HasParseError() || !d.IsArray()) {
     //CCLOG("解析JSON对象错误");
     return NULL;
     }
     
     for (int i = 0; i < d.Size(); ++i) {
     rapidjson::Value &v = d[i];
     
     const char *key = v["k"].GetString();
     const char *typeStr = v["t"].GetString();
     
     
     //CCLOG("读取%s,类型为%s",key,typeStr);
     
     //        putValue(key, typeStr, output, pack);
     
     if (strcmp(typeStr, "int")==0) {
     int vv;
     pack >> vv;
     //CCLOG("值为:%d",vv);
     output.AddMember(key, vv, allocator);
     }else if (strcmp(typeStr, "string")==0){
     std::string vv;
     pack >> vv;
     __String *ss = __String::createWithFormat("%s",vv.c_str());
     //CCLOG("值为:%s",vv.c_str());
     output.AddMember(key, ss->getCString(), allocator);
     }else if (strcmp(typeStr, "long")==0){
     int64 vv;
     pack >> vv;
     //CCLOG("值为:%lld",vv);
     output.AddMember(key, vv, allocator);
     }else if (strcmp(typeStr, "byte")==0){
     int8 vv;
     pack >> vv;
     //CCLOG("值为:%d",vv);
     output.AddMember(key, vv, allocator);
     }else if (strcmp(typeStr, "short")==0){
     int16 vv;
     pack >> vv;
     //CCLOG("值为:%d",vv);
     output.AddMember(key, vv, allocator);
     }else if (strcmp(typeStr, "bool")==0){
     int8 vv;
     pack >> vv;
     //CCLOG("值为:%d",vv);
     output.AddMember(key, vv, allocator);
     }else if (strcmp(typeStr, "double")==0){
     double vv;
     pack >> vv;
     //CCLOG("值为:%f",vv);
     output.AddMember(key, vv, allocator);
     }else if (strcmp(typeStr, "float")==0){
     float vv;
     pack >> vv;
     //CCLOG("值为:%f",vv);
     output.AddMember(key, vv, allocator);
     }else if (strcmp(typeStr, "object")==0){
     //            int64 vv;
     //            pack >> vv;
     //            output.AddMember(key, vv, allocator);
     }else if (strcmp(typeStr, "array")==0){
     //            int64 vv;
     //            pack >> vv;
     //            output.AddMember(key, vv, allocator);
     }
     }
     
     rapidjson::StringBuffer buffer;
     rapidjson::Writer<rapidjson::StringBuffer> writer(buffer);
     
     output.Accept(writer);
     
     //    auto out = buffer.GetString();
     
     //    //CCLOG("%s",buffer.GetString());
     
     //    const char *out = buffer.GetString();
     
     __String *ss = __String::createWithFormat("%s",buffer.GetString());
     
     //    std::string outstring = buffer.GetString();
     
     //    //CCLOG("%s",ss->getCString());
     
     //    char *ret;
     //
     //    strcpy(ret, out);
     
     return ss->getCString();
     */
}

cocos2d::LuaValueDict NetpackHelper::bufToLuaValue(const char *buf,int buflen)
{

	ByteBuffer pack;
    pack.append(buf,buflen);
    
    int packtype;
    int packindex;
    pack >> packtype;
    pack >> packindex;

	

	//log("unpack %d %d",packtype,packindex);

	//读取Json文件，按顺序解析对象

	std::string sPackType = createStrWithFormat("%d",packtype);
	std::string sPackIndex = createStrWithFormat("%d",packindex);

	//time_t start = clock();
	
	LuaValueDict dict = converBufToLuaDict(&pack,sPackType.c_str());

	dict.insert(dict.end(),LuaValueDict::value_type("_packtype", LuaValue::stringValue(sPackType)));
	dict.insert(dict.end(),LuaValueDict::value_type("_packindex", LuaValue::stringValue(sPackIndex)));
	//time_t end = clock();
	//CCLOG("the running time is : %f%s\n", double(end -start)/CLOCKS_PER_SEC, sPackType.c_str());
	return dict;
}

void NetpackHelper::decodeArray(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& tmpArray1, int arraylen1)
{
	//CCLOG("decodeArray");
	LuaValueArray tmpArray;

    //读取数组长度
	//要先判断数组类型，如果是byte的话，数组的长度为int型，其余的是short型
	//const char *arrayType = v["arraytype"].GetString();
	int arraylen;
	if (strcmp(arrayType, "byte")==0)
	{
		*pack >> arraylen;
	}else{
		short tmplen;
		*pack >> tmplen;
		arraylen = (tmplen);
	}
             
    if (arraylen == 0) {
        //空数组
		dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::arrayValue(tmpArray)));
		//continue;
		return;
       // return -1;
    }
	if(!isExistsType(arrayType))
	{
		((FP)htmap["object_a"])(dict, pack, key, typeStr, arrayType, tmpArray, arraylen);
	}
    /*if (isObject(arrayType)) {
		//对象的数组
        for (int x = 0; x < arraylen; ++x) {
			//判断对象是否为空
			int8 hasObj;
			*pack >> hasObj;

			if (hasObj == 0) {
				//0为空对象
				LuaValueDict tmpDict;
				//dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::dictValue(tmpDict)));
				tmpArray.push_back(LuaValue::dictValue(tmpDict));
			}else{
				tmpArray.push_back(LuaValue::dictValue(converBufToLuaDict(pack,arrayType)));
			}
					//dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::dictValue(tmpDict)));
         }
      }*/else{
          for (int x = 0; x < arraylen; ++x) {
			//addValueToLuaArrayByType(tmpArray,arrayType,pack);
			 std::string g = arrayType;
			((FP)htmap[g + "_a"])(dict, pack, key, typeStr, arrayType, tmpArray, 0);
          }
      }
	 dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::arrayValue(tmpArray)));
	 //return 0;
}

void NetpackHelper::init()
{
	 fp_array=decodeArray;
	 fp_object=decodeObject;
	 fp_string=decodeString;
	 fp_long=decodeLong;
	 fp_int=decodeInt;
	 fp_short=decodeShort;
	 fp_byte=decodeByte;
	 fp_boolean=decodeBoolean;
	 fp_float=decodeFloat;
	 fp_double=decodeDouble;

	 fp_object_arr=decodeObjectArr;
	 fp_string_arr=decodeStringArr;
	 fp_long_arr=decodeLongArr;
	 fp_int_arr=decodeIntArr;
	 fp_short_arr=decodeShortArr;
	 fp_byte_arr=decodeByteArr;
	 fp_boolean_arr=decodeBooleanArr;
	 fp_float_arr=decodeFloatArr;
	 fp_double_arr=decodeDoubleArr;

	 htmap["array"] = fp_array;
	 htmap["object"] = fp_object;
	 htmap["string"] = fp_string;
	 htmap["long"] = fp_long;
	 htmap["int"] = fp_int;
	 htmap["short"] = fp_short;
	 htmap["byte"] = fp_byte;
	 htmap["bool"] = fp_boolean;
	 htmap["float"] = fp_float;
	 htmap["double"] = fp_double;

	 htmap["object_a"] = fp_object_arr;
	 htmap["string_a"] = fp_string_arr;
	 htmap["long_a"] = fp_long_arr;
	 htmap["int_a"] = fp_int_arr;
	 htmap["short_a"] = fp_short_arr;
	 htmap["byte_a"] = fp_byte_arr;
	 htmap["bool_a"] = fp_boolean_arr;
	 htmap["float_a"] = fp_float_arr;
	 htmap["double_a"] = fp_double_arr;
	
	 typeMap["string"] = 1;
	 typeMap["long"] = 2;
	 typeMap["int"] = 3;
	 typeMap["short"] = 4;
	 typeMap["byte"] = 5;
	 typeMap["bool"] = 6;
	 typeMap["float"] = 7;
	 typeMap["double"] = 8;

	//cout<<"hello!world";
	/*((FP)htmap["array"])("==========");
	((FP)htmap["object"])("==========");
	((FP)htmap["string"])("==========");
	((FP)htmap["long"])("==========");
	((FP)htmap["int"])("==========");
	((FP)htmap["short"])("==========");
	((FP)htmap["byte"])("==========");
	((FP)htmap["boolean"])("==========");

	((FP)htmap["float"])("==========");
	((FP)htmap["double"])("==========");*/
	
}


void NetpackHelper::decodeObject(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& tmpArray, int arraylen)
{
	//CCLOG("decodeObject");
	//是对象
	LuaValueDict tmpDict;

	//判断对象是否为空
	int8 hasObj;
	*pack >> hasObj;
        
	if (hasObj == 0) {
		//0为空对象
		//CCLOG("对象为空");
		dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::dictValue(tmpDict)));
	}else{
		dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::dictValue(converBufToLuaDict(pack,typeStr))));
	}
	
}

void NetpackHelper::decodeString(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& tmpArray, int arraylen)
{
	//CCLOG("decodeString");
	std::string vv;
    *pack >> vv;
    //CCLOG("读取[string],值为:%s",vv.c_str());
	dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::stringValue(vv)));
	
}
void NetpackHelper::decodeLong(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& tmpArray, int arraylen)
{
	//CCLOG("decodeLong");
    int64 vv;
    *pack >> vv;
   // CCLOG("读取[long],值为:%lld",vv);
	dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::intValue(vv)));
}
void NetpackHelper::decodeInt(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& tmpArray, int arraylen)
{
	//CCLOG("decodeInt");
	int vv;
    *pack >> vv;
   // CCLOG("读取[int],值为:%d",vv);
	dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::intValue(vv)));
	
}
void NetpackHelper::decodeShort(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& tmpArray, int arraylen)
{
	//CCLOG("decodeShort");
    int16 vv;
    *pack >> vv;
    //CCLOG("读取[short],值为:%d",vv);
	dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::intValue(vv)));
	
}
void NetpackHelper::decodeByte(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& tmpArray, int arraylen)
{
	//CCLOG("decodeByte");
    int8 vv;
    *pack >> vv;
    //CCLOG("读取[byte],值为:%d",vv);
	dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::intValue(vv)));
	
}
void NetpackHelper::decodeBoolean(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& tmpArray, int arraylen)
{
	//CCLOG("decodeBoolean");
    int8 vv;
    *pack >> vv;
    //CCLOG("读取[bool],值为:%d",vv);
	dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::intValue(vv)));
	
}
void NetpackHelper::decodeFloat(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& tmpArray, int arraylen)
{
	//CCLOG("decodeFloat");
    float vv;
    *pack >> vv;
    //CCLOG("读取[float],值为:%f",vv);
	dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::floatValue(vv)));
	
}

void NetpackHelper::decodeDouble(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& tmpArray, int arraylen)
{
	//CCLOG("decodeDouble");
    double vv;
    *pack >> vv;
    //CCLOG("读取[double],值为:%f",vv);
	dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::floatValue(vv)));
}

void NetpackHelper::decodeObjectArr(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& tmpArray, int arraylen)
{
	//CCLOG("decodeObjectArr");
	//对象的数组
	for (int x = 0; x < arraylen; ++x) {
		//判断对象是否为空
		int8 hasObj;
		*pack >> hasObj;	
		if (hasObj == 0) {
			//0为空对象
			LuaValueDict tmpDict;
			//dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::dictValue(tmpDict)));
			tmpArray.push_back(LuaValue::dictValue(tmpDict));
		}else{
			tmpArray.push_back(LuaValue::dictValue(converBufToLuaDict(pack,arrayType)));
		}
	//dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::dictValue(tmpDict)));
	}
	
}

void NetpackHelper::decodeStringArr(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& lArray, int arraylen)
{
	//CCLOG("decodeStringArr");
    std::string vv;
    *pack >> vv;
    //CCLOG("读取[string],值为:%s",vv.c_str());
	lArray.push_back(LuaValue::stringValue(vv));
	
}
void NetpackHelper::decodeLongArr(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& lArray, int arraylen)
{
	//CCLOG("decodeLongArr");
	int64 vv;
	*pack >> vv;
    //CCLOG("读取[long],值为:%lld",vv);
	lArray.push_back(LuaValue::intValue(vv));
	
}
void NetpackHelper::decodeIntArr(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& lArray, int arraylen)
{
	//CCLOG("decodeIntArr");
	int vv;
	*pack >> vv;
	//CCLOG("读取[int],值为:%d",vv);
	lArray.push_back(LuaValue::intValue(vv));
	
}
void NetpackHelper::decodeShortArr(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& lArray, int arraylen)
{
	//CCLOG("decodeShortArr");
    int16 vv;
    *pack >> vv;
    //CCLOG("读取[short],值为:%d",vv);
	lArray.push_back(LuaValue::intValue(vv));
	
}
void NetpackHelper::decodeByteArr(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& lArray, int arraylen)
{
	//CCLOG("decodeByteArr");
    int8 vv;
    *pack >> vv;
    //CCLOG("读取[byte],值为:%d",vv);
    lArray.push_back(LuaValue::intValue(vv));
	
}
void NetpackHelper::decodeBooleanArr(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& lArray, int arraylen)
{
	//CCLOG("decodeBooleanArr");
    int8 vv;
    *pack >> vv;
    //CCLOG("读取[bool],值为:%d",vv);
	lArray.push_back(LuaValue::intValue(vv));
	
}
void NetpackHelper::decodeFloatArr(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& lArray, int arraylen)
{
	//CCLOG("decodeFloatArr");
    float vv;
    *pack >> vv;
    //CCLOG("读取[float],值为:%f",vv);
	lArray.push_back(LuaValue::floatValue(vv));
	
}

void NetpackHelper::decodeDoubleArr(LuaValueDict& dict, ByteBuffer *pack, const char *key, const char *typeStr, const char *arrayType, LuaValueArray& lArray, int arraylen)
{
	//CCLOG("decodeDoubleArr");
    double vv;
    *pack >> vv;
    //CCLOG("读取[double],值为:%f",vv);
	lArray.push_back(LuaValue::floatValue(vv));
	
}

cocos2d::LuaValueDict NetpackHelper::converBufToLuaDict(ByteBuffer *pack,const char *objectName)
{
	//time_t start = clock();
	LuaValueDict dict;
	//TODO 多余的
	LuaValueArray va;
	//std::string temp = objectName;
	
	Document* p = NULL;
	std::unordered_map<std::string, Document *>::iterator itr = objMap.find(objectName);
	if(itr == objMap.end())
	{
		std::string paths = getJsonFilePath(objectName);
    //    const char *path = __String::createWithFormat("src/Network/Response/%s.json",objectName)->getCString();
		std::string fileStr = FileUtils::getInstance()->getStringFromFile(paths);
		if (fileStr == "") 
		{
			return dict;
		}
		p = new Document();
		p->Parse<0>(fileStr.c_str());

		if (p->HasParseError() || !p->IsArray()) {
			//CCLOG("解析JSON对象错误");
			log("解析协议Json对象错误");
			return dict;
		}

		objMap.insert(std::make_pair(objectName,p));
	}
	else
	{
		p = itr->second;
	}
	if(p==NULL)
		return dict;
	

	//获取解析对象的Json文件
	/*std::string paths = getJsonFilePath(objectName);
    //    const char *path = __String::createWithFormat("src/Network/Response/%s.json",objectName)->getCString();
    std::string fileStr = FileUtils::getInstance()->getStringFromFile(paths);
    if (fileStr == "") {
        return dict;
    }
    Document d; //用于解析模版
    d.Parse<0>(fileStr.c_str());

	if (d.HasParseError() || !d.IsArray()) {
        //CCLOG("解析JSON对象错误");
		log("解析协议Json对象错误");
        return dict;
    }*/
	
	for (unsigned int i = 0; i < p->Size(); ++i) {
        rapidjson::Value &v = (*p)[i];
        
        const char *key = v["k"].GetString();
        const char *typeStr = v["t"].GetString();
		//dict,pack,key,type,arrayType,luaValueArray,arrayLen
		std::string typeStrTemp = typeStr;
		//const char *gt;
		if(v["arraytype"].IsNull()){
			//CCLOG("null");
			if(isExistsType(typeStrTemp))
			{
				((FP)htmap[typeStrTemp])(dict, pack, key, typeStr, "", va, 0);
			}else
			{
				((FP)htmap["object"])(dict, pack, key, typeStr, "", va, 0);
			}
		}else{
			((FP)htmap[typeStrTemp])(dict, pack, key, typeStr, v["arraytype"].GetString(), va, 0);
		}
	
		//const char *arrayType = v["arraytype"].GetString();

		
    }
	//time_t end = clock();
	//CCLOG("the running time is === : %f%s\n", double(end -start)/CLOCKS_PER_SEC, paths.c_str());
	return dict;
}

bool NetpackHelper::isExistsType(std::string typeStr)
{
//	CCLOG("###-------------------%d", typeMap[typeStr]);
	return typeMap[typeStr] != 0;
}

/*cocos2d::LuaValueDict NetpackHelper::converBufToLuaDict(ByteBuffer *pack,const char *objectName)
{
	time_t start = clock();
	LuaValueDict dict;

	//获取解析对象的Json文件
	std::string paths = getJsonFilePath(objectName);
    
    //    const char *path = __String::createWithFormat("src/Network/Response/%s.json",objectName)->getCString();
    std::string fileStr = FileUtils::getInstance()->getStringFromFile(paths);
    
    if (fileStr == "") {
        return dict;
    }
    
    Document d; //用于解析模版
    d.Parse<0>(fileStr.c_str());

	if (d.HasParseError() || !d.IsArray()) {
        //CCLOG("解析JSON对象错误");
		log("解析协议Json对象错误");
        return dict;
    }



	for (int i = 0; i < d.Size(); ++i) {
        rapidjson::Value &v = d[i];
        
        const char *key = v["k"].GetString();
        const char *typeStr = v["t"].GetString();
        
        if (isObject(typeStr)) {
            //是对象
			LuaValueDict tmpDict;

			//判断对象是否为空
			int8 hasObj;
			*pack >> hasObj;
        
			if (hasObj == 0) {
				//0为空对象
				//CCLOG("对象为空");
				dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::dictValue(tmpDict)));
			}else{
				dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::dictValue(converBufToLuaDict(pack,typeStr))));
			}
        }else if (isArray(typeStr)){
            //是数组

			LuaValueArray tmpArray;

            //读取数组长度

			//要先判断数组类型，如果是byte的话，数组的长度为int型，其余的是short型
			const char *arrayType = v["arraytype"].GetString();
			int arraylen;
			if (strcmp(arrayType, "byte")==0)
			{
				*pack >> arraylen;
			}else{
				short tmplen;
				*pack >> tmplen;
				arraylen = (tmplen);
			}
             
            if (arraylen == 0) {
                //空数组
				dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::arrayValue(tmpArray)));
                continue;
            }
            if (isObject(arrayType)) {
				//对象的数组
                for (int x = 0; x < arraylen; ++x) {
					//判断对象是否为空
					int8 hasObj;
					*pack >> hasObj;

					
					if (hasObj == 0) {
						//0为空对象
						LuaValueDict tmpDict;
						//dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::dictValue(tmpDict)));
						tmpArray.push_back(LuaValue::dictValue(tmpDict));
					}else{
						tmpArray.push_back(LuaValue::dictValue(converBufToLuaDict(pack,arrayType)));
					}
					//dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::dictValue(tmpDict)));
                }
            }else{
                for (int x = 0; x < arraylen; ++x) {
					addValueToLuaArrayByType(tmpArray,arrayType,pack);
                }
            }
			dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::arrayValue(tmpArray)));
        }else{
			addValueToLuaDictByType(dict,typeStr,pack,key);
        }
    }
	time_t end = clock();
	CCLOG("the running time is === : %f%s\n", double(end -start)/CLOCKS_PER_SEC, paths.c_str());
	return dict;
}*/

void NetpackHelper::addValueToLuaDictByType(LuaValueDict& dict,const char *typeStr,ByteBuffer *pack,const char *key)
{
	std::string retStr = "";
    if (strcmp(typeStr, "int")==0) {
        int vv;
        *pack >> vv;
        //CCLOG("读取[int],值为:%d",vv);
		dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::intValue(vv)));
    }else if (strcmp(typeStr, "string")==0){
        std::string vv;
        *pack >> vv;
        //CCLOG("读取[string],值为:%s",vv.c_str());
		dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::stringValue(vv)));
    }else if (strcmp(typeStr, "long")==0){
        int64 vv;
        *pack >> vv;
        //CCLOG("读取[long],值为:%lld",vv);
		dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::intValue(vv)));
    }else if (strcmp(typeStr, "byte")==0){
        int8 vv;
        *pack >> vv;
        //CCLOG("读取[byte],值为:%d",vv);
		dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::intValue(vv)));
    }else if (strcmp(typeStr, "short")==0){
        int16 vv;
        *pack >> vv;
        //CCLOG("读取[short],值为:%d",vv);
		dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::intValue(vv)));
    }else if (strcmp(typeStr, "bool")==0){
        int8 vv;
        *pack >> vv;
        //CCLOG("读取[bool],值为:%d",vv);
		dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::intValue(vv)));
    }else if (strcmp(typeStr, "double")==0){
        double vv;
        *pack >> vv;
        //CCLOG("读取[double],值为:%f",vv);
		dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::floatValue(vv)));
    }else if (strcmp(typeStr, "float")==0){
        float vv;
        *pack >> vv;
        //CCLOG("读取[float],值为:%f",vv);
		dict.insert(dict.end(),LuaValueDict::value_type(key,LuaValue::floatValue(vv)));
    }
}

void NetpackHelper::addValueToLuaArrayByType(LuaValueArray& lArray,const char *typeStr,ByteBuffer *pack)
{
	std::string retStr = "";
    if (strcmp(typeStr, "int")==0) {
        int vv;
        *pack >> vv;
        //CCLOG("读取[int],值为:%d",vv);
		lArray.push_back(LuaValue::intValue(vv));
    }else if (strcmp(typeStr, "string")==0){
        std::string vv;
        *pack >> vv;
        //CCLOG("读取[string],值为:%s",vv.c_str());
		lArray.push_back(LuaValue::stringValue(vv));
    }else if (strcmp(typeStr, "long")==0){
        int64 vv;
        *pack >> vv;
        //CCLOG("读取[long],值为:%lld",vv);
		lArray.push_back(LuaValue::intValue(vv));
    }else if (strcmp(typeStr, "byte")==0){
        int8 vv;
        *pack >> vv;
        //CCLOG("读取[byte],值为:%d",vv);
        lArray.push_back(LuaValue::intValue(vv));
    }else if (strcmp(typeStr, "short")==0){
        int16 vv;
        *pack >> vv;
        //CCLOG("读取[short],值为:%d",vv);
		lArray.push_back(LuaValue::intValue(vv));
    }else if (strcmp(typeStr, "bool")==0){
        int8 vv;
        *pack >> vv;
        //CCLOG("读取[bool],值为:%d",vv);
		lArray.push_back(LuaValue::intValue(vv));
    }else if (strcmp(typeStr, "double")==0){
        double vv;
        *pack >> vv;
        //CCLOG("读取[double],值为:%f",vv);
		lArray.push_back(LuaValue::floatValue(vv));
    }else if (strcmp(typeStr, "float")==0){
        float vv;
        *pack >> vv;
        //CCLOG("读取[float],值为:%f",vv);
		lArray.push_back(LuaValue::floatValue(vv));
    }
}

//是否对象类型
bool NetpackHelper::isObject(const char *typeStr)
{
    if (strcmp(typeStr, "int")==0
        || strcmp(typeStr, "string")==0
        || strcmp(typeStr, "long")==0
        || strcmp(typeStr, "byte")==0
        || strcmp(typeStr, "short")==0
        || strcmp(typeStr, "bool")==0
        || strcmp(typeStr, "double")==0
        || strcmp(typeStr, "float")==0
        || strcmp(typeStr, "array")==0
        ) {
        return false;
    }else{
        return true;
    }
}

bool NetpackHelper::isArray(const char *typeStr)
{
    return strcmp(typeStr, "array") == 0;
}

void NetpackHelper::appendStr(std::string& source,const std::string& str)
{
    source.append(str);
}

void NetpackHelper::appendStrWithFormat(std::string& source,const char* format, ...)
{
    va_list ap;
    va_start(ap, format);
    
    char* pBuf = (char*)malloc(1024*100);
    if (pBuf != NULL)
    {
        vsnprintf(pBuf, 1024*100, format, ap);
        source.append(pBuf);
        free(pBuf);
    }
    
    va_end(ap);
}

std::string NetpackHelper::createStrWithFormat(const char *format, ...)
{
    va_list ap;
    va_start(ap, format);
    
    std::string ret;
    
    char* pBuf = (char*)malloc(1024*100);
    if (pBuf != NULL)
    {
        vsnprintf(pBuf, 1024*100, format, ap);
        ret = pBuf;
        free(pBuf);
    }
    
    va_end(ap);
    
    return ret;
}

std::string NetpackHelper::getValueString(const char *key, const char *typeStr, ByteBuffer *pack)
{
    std::string retStr = "";
    if (strcmp(typeStr, "int")==0) {
        int vv;
        *pack >> vv;
        //CCLOG("读取%s[int],值为:%d",key,vv);
        appendStrWithFormat(retStr, "\"%s\":%d",key,vv);
        //        json->appendWithFormat("\"%s\":%d",key,vv);
    }else if (strcmp(typeStr, "string")==0){
        std::string vv;
        *pack >> vv;
        std::string ss = createStrWithFormat("%s",vv.c_str());
        //CCLOG("读取%s[string],值为:%s",key,vv.c_str());
		appendStrWithFormat(retStr, "\"%s\":\"%s\"",key,ss.c_str());
        //        json->appendWithFormat("\"%s\":\"%s\"",key,ss->getCString());
    }else if (strcmp(typeStr, "long")==0){
        int64 vv;
        *pack >> vv;
        //CCLOG("读取%s[long],值为:%lld",key,vv);
        appendStrWithFormat(retStr, "\"%s\":%lld",key,vv);
        //        json->appendWithFormat("\"%s\":%lld",key,vv);
    }else if (strcmp(typeStr, "byte")==0){
        int8 vv;
        *pack >> vv;
        //CCLOG("读取%s[byte],值为:%d",key,vv);
        appendStrWithFormat(retStr, "\"%s\":%d",key,vv);
        //        json->appendWithFormat("\"%s\":%d",key,vv);
    }else if (strcmp(typeStr, "short")==0){
        int16 vv;
        *pack >> vv;
        //CCLOG("读取%s[short],值为:%d",key,vv);
        appendStrWithFormat(retStr, "\"%s\":%d",key,vv);
        //        json->appendWithFormat("\"%s\":%d",key,vv);
    }else if (strcmp(typeStr, "bool")==0){
        int8 vv;
        *pack >> vv;
        //CCLOG("读取%s[bool],值为:%d",key,vv);
        appendStrWithFormat(retStr, "\"%s\":%d",key,vv);
        //        json->appendWithFormat("\"%s\":%d",key,vv);
    }else if (strcmp(typeStr, "double")==0){
        double vv;
        *pack >> vv;
        //CCLOG("读取%s[double],值为:%f",key,vv);
        appendStrWithFormat(retStr, "\"%s\":%f",key,vv);
        //        json->appendWithFormat("\"%s\":%f",key,vv);
    }else if (strcmp(typeStr, "float")==0){
        float vv;
        *pack >> vv;
        //CCLOG("读取%s[float],值为:%f",key,vv);
        appendStrWithFormat(retStr, "\"%s\":%f",key,vv);
        //        json->appendWithFormat("\"%s\":%f",key,vv);
    }
    
    return retStr;
}

std::string NetpackHelper::getValueStringForArray(const char *typeStr,ByteBuffer *pack)
{
	std::string retStr = "";
    if (strcmp(typeStr, "int")==0) {
        int vv;
        *pack >> vv;
        //CCLOG("读取[int],值为:%d",vv);
        appendStrWithFormat(retStr, "%d",vv);
        //        json->appendWithFormat("\"%s\":%d",key,vv);
    }else if (strcmp(typeStr, "string")==0){
        std::string vv;
        *pack >> vv;
        std::string ss = createStrWithFormat("%s",vv.c_str());
        //CCLOG("读取[string],值为:%s",vv.c_str());
		appendStrWithFormat(retStr, "\"%s\"",ss.c_str());
        //        json->appendWithFormat("\"%s\":\"%s\"",key,ss->getCString());
    }else if (strcmp(typeStr, "long")==0){
        int64 vv;
        *pack >> vv;
        //CCLOG("读取[long],值为:%lld",vv);
        appendStrWithFormat(retStr, "%lld",vv);
        //        json->appendWithFormat("\"%s\":%lld",key,vv);
    }else if (strcmp(typeStr, "byte")==0){
        int8 vv;
        *pack >> vv;
        //CCLOG("读取[byte],值为:%d",vv);
        appendStrWithFormat(retStr, "%d",vv);
        //        json->appendWithFormat("\"%s\":%d",key,vv);
    }else if (strcmp(typeStr, "short")==0){
        int16 vv;
        *pack >> vv;
        //CCLOG("读取[short],值为:%d",vv);
        appendStrWithFormat(retStr, "%d",vv);
        //        json->appendWithFormat("\"%s\":%d",key,vv);
    }else if (strcmp(typeStr, "bool")==0){
        int8 vv;
        *pack >> vv;
        //CCLOG("读取[bool],值为:%d",vv);
        appendStrWithFormat(retStr, "%d",vv);
        //        json->appendWithFormat("\"%s\":%d",key,vv);
    }else if (strcmp(typeStr, "double")==0){
        double vv;
        *pack >> vv;
        //CCLOG("读取[double],值为:%f",vv);
        appendStrWithFormat(retStr, "%f",vv);
        //        json->appendWithFormat("\"%s\":%f",key,vv);
    }else if (strcmp(typeStr, "float")==0){
        float vv;
        *pack >> vv;
        //CCLOG("读取[float],值为:%f",vv);
        appendStrWithFormat(retStr, "%f",vv);
        //        json->appendWithFormat("\"%s\":%f",key,vv);
    }
    
    return retStr;
}

std::string NetpackHelper::getObjectString(ByteBuffer *pack, const char *objectName,bool checkEmpty)
{
    return getObjectString(pack, objectName,-1,-1,checkEmpty);
}

std::string NetpackHelper::getObjectString(ByteBuffer *pack, const char *objectName, int packtype, int packindex,bool checkEmpty)
{
    //CCLOG("读取对象：%s",objectName);
    
    //用一个short表示对象是否为空
    if (checkEmpty) {
        int8 hasObj;
        *pack >> hasObj;
        
        if (hasObj == 0) {
            //0为空对象
            //CCLOG("对象为空");
            return "";
        }
    }
    
    //std::string paths = createStrWithFormat("src/Network/Response/%s.json",objectName);
	std::string paths = getJsonFilePath(objectName);
    
    //    const char *path = __String::createWithFormat("src/Network/Response/%s.json",objectName)->getCString();
    std::string fileStr = FileUtils::getInstance()->getStringFromFile(paths);
    
    if (fileStr == "") {
        return NULL;
    }
    
    Document d; //用于解析模版
    d.Parse<0>(fileStr.c_str());
    
    
    std::string ret = "{";
    //    __String *ret = __String::create("{");
    
    if (packindex != -1 && packtype != -1) {
        //        ret->appendWithFormat("\"_packtype\":\"%d\",",packtype);
        //        ret->appendWithFormat("\"_packindex\":\"%d\",",packindex);
        appendStrWithFormat(ret, "\"_packtype\":\"%d\",",packtype);
        appendStrWithFormat(ret, "\"_packindex\":\"%d\",",packindex);
    }
    
    if (d.HasParseError() || !d.IsArray()) {
        //CCLOG("解析JSON对象错误");
        return NULL;
    }
    
    for (unsigned int i = 0; i < d.Size(); ++i) {
        rapidjson::Value &v = d[i];
        
        const char *key = v["k"].GetString();
        const char *typeStr = v["t"].GetString();
        
        if (isObject(typeStr)) {
            //是对象
            //                        ret->appendWithFormat("\"%s\":",key);
            appendStrWithFormat(ret, "\"%s\":",key);
            std::string str = getObjectString(pack, typeStr);
            ret.append(str);
            //            const char *str = getObjectString(pack, typeStr);
            //            ret->append(str);
            //            ret->append("}");
            
            if (strcmp(str.c_str(), "")==0) {
                //                ret->append("\"\"");
                ret.append("\"\",");
                continue;
            }
        }else if (isArray(typeStr)){
            //是数组
            //读取数组长度

			//要先判断数组类型，如果是byte的话，数组的长度为int型，其余的是short型
			const char *arrayType = v["arraytype"].GetString();
			int arraylen;
			if (strcmp(arrayType, "byte")==0)
			{
				*pack >> arraylen;
			}else{
				short tmplen;
				*pack >> tmplen;
				arraylen = (tmplen);
			}
            /*short arraylen;
            *pack >> arraylen;
            const char *arrayType = v["arraytype"].GetString();*/
            //CCLOG("准备读取array[%s]，长度为%d",arrayType,arraylen);
            appendStrWithFormat(ret, "\"%s\":[",key);
            //            ret->appendWithFormat("\"%s\":[",key);
            if (arraylen == 0) {
                ret.append("],");
                //                ret->append("],");
                continue;
            }
            if (isObject(arrayType)) {
                for (int x = 0; x < arraylen; ++x) {
                    std::string str = getObjectString(pack, arrayType);
                    //                    const char *str = getObjectString(pack, arrayType);
                    if (strcmp(str.c_str(), "")!=0) {
                        ret.append(str);
                        //                        ret->append(str);
                        if (x < arraylen-1) {
                            ret.append(",");
                            //                            ret->append(",");
                        }
                    }
                }
            }else{
                for (int x = 0; x < arraylen; ++x) {
                    ret.append(getValueStringForArray(arrayType, pack));
                    
                    //                    putValue(key, typeStr, pack, ret);
                    if (x < arraylen-1) {
                        ret.append(",");
                        //                        ret->append(",");
                    }
                }
            }
            ret.append("]");
            //            ret->append("]");
        }else{
            ret.append(getValueString(key, typeStr, pack));
            //            putValue(key, typeStr, pack, ret);
        }
        
        if (i < d.Size()-1) {
            ret.append(",");
            //            ret->append(",");
        }
    }
    
    //删除最后一个逗号
    //    std::string result = ret->getCString();
    std::string lastchar = ret.substr(ret.length()-1,1);
    
    //CCLOG("最后一个字符：%s",lastchar.c_str());
    
    if (strcmp(lastchar.c_str(), ",")==0) {
        std::string real = ret.substr(0,ret.length()-1);
        real.append("}");
        return real;
        //        return __String::createWithFormat("%s}",real.c_str())->getCString();
    }
    
    
    ret.append("}");
    //    ret->append("}");
    
    return ret;
}

std::string NetpackHelper::getJsonFilePath(const char* objectName)
{
	static Document ResponseJson;

    std::string fileStr = FileUtils::getInstance()->getStringFromFile("src/Network/ResponsePackpath.json");    
    
    Document d; //用于解析模版
    d.Parse<0>(fileStr.c_str());

	
	rapidjson::Value &v = d[objectName];
	
	return createStrWithFormat("src/Network/Response/%s.json",v.GetString());
}