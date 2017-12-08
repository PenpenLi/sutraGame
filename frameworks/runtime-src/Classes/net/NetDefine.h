
#pragma once


#include <string>
#include "TypeDefine.h"
#include "ByteBuffer.h"


//////////////////////////////////////////////////////////////////////////


#define NET_PACKET_DATA_SIZE 1024 
#define NET_PACKET_SIZE (sizeof(NetPacketHeader) + NET_PACKET_DATA_SIZE) * 10


//////////////////////////////////////////////////////////////////////////


/// 网络数据包包头
struct NetPacketHeader
{
	unsigned short		wDataSize;	///< 数据包大小，表示数据包长度，不含包头
};

/// 网络数据包
struct NetPacket
{
	NetPacketHeader		Header;							///< 包头
	unsigned char		Data[NET_PACKET_DATA_SIZE];		///< 数据
};


struct BasePacket {
    int32 _packhead;
    int32 _packtype;
    int32 _packindex;
};


//////////////////////////////////////////////////////////////////////////


/// 网络操作码
enum eNetOpcode
{
	NET_TEST_POD			= 1,	///< 测试原生数据直接拷贝
	NET_TEST_SERIALIZE		= 2,	///< 测试序列化
};

struct NetPacket_EnterGameResponse
{
    /*
     output.writeBoolean(isSuccess);
     output.writeInt(result);
     output.writeObject(player);
     output.writeInt(playerMaxLevel);
     output.writeList(soldierSnapList);
     */
    bool isSuccess;
    int result;
};

struct NetPacket_Test_Request
{
    /*
     _byte = input.readByte();
     _boolean = input.readBoolean();
     _short = input.readShort();
     _int = input.readInt();
     _float = input.readFloat();
     _double = input.readDouble();
     
     _long = input.readLong();
     _string = input.readUTF();
     */
    int32 _packhead;
    int32 _packtype;
    int32 _packindex;
    int8 _byte;
    int8 _boolean;
    int16 _short;
    int _int;
    float _float;
    double _double;
    uint64 _long;
    std::string _string;
};

struct NetPacket_Test_Response
{
    int _packhead;
    int _packtype;
    int _packindex;
    int8 _byte;
    int8 _boolean;
    int16 _short;
    int _int;
    float _float;
    double _double;
    int64 _long;
    short _strlen;
    std::string _string;
};

NET_APPEND(NetPacket_Test_Request)
{
    /*
     _byte = input.readByte();
     _boolean = input.readBoolean();
     _short = input.readShort();
     _int = input.readInt();
     _float = input.readFloat();
     _double = input.readDouble();
     
     _long = input.readLong();
     _string = input.readUTF();
     */
    
    lht << rht._packhead
        << rht._packtype
        << rht._packindex
        << rht._byte
        << rht._boolean
        << rht._short
        << rht._int
        << rht._float
        << rht._double
        << rht._long
        << rht._string;
    return lht;
};

NET_READ(NetPacket_Test_Response)
{
    lht >> rht._packhead
        >> rht._packtype
        >> rht._packindex
        >> rht._byte
        >> rht._boolean
        >> rht._short
        >> rht._int
        >> rht._float
        >> rht._double
        >> rht._long
        >> rht._string;
    return lht;
}

///注册请求
struct NetPacket_Regist_Request
{
    //    /** 用户名<br>
    //     * Java type is : <font color=#0000ff>java.lang.String</font>*/
    //	public String username  = null;
    //
    //	/** 密码<br>
    //     * Java type is : <font color=#0000ff>java.lang.String</font>*/
    //	public String password = null;
    //
    //	/** 终端平台类型：pc、ios、android<br>
    //     * Java type is : <font color=#0000ff>java.lang.String</font>*/
    //	public String terminalType  = null;
    //
    //	/** 终端型号<br>
    //     * Java type is : <font color=#0000ff>java.lang.String</font>*/
    //	public String terminalPlatform  = null;
    //
    //	/** 发布渠道标识<br>
    //     * Java type is : <font color=#0000ff>java.lang.String</font>*/
    //	public String publishChannel  = null;
    //
    //	/** 客户端版本<br>
    //     * Java type is : <font color=#0000ff>java.lang.String</font>*/
    //	public String version  = null;
    
    std::string username;           //用户名
    std::string password;           //密码
    std::string terminalType;       //终端平台类型
    std::string terminalPlatform;   //终端型号
    std::string publishChannel;     //发布渠道标识
    std::string version;            //客户端版本
};

struct NetPacket_Regist_Response
{
    int result;
    int res;
};

NET_APPEND(NetPacket_Regist_Request)
{
    lht << rht.username
        << rht.password
        << rht.terminalType
        << rht.terminalPlatform
        << rht.publishChannel
        << rht.version;
    return lht;
};

NET_READ(NetPacket_Regist_Response)
{
    lht >> rht.result
        >> rht.res;
    return lht;
};

struct NetPacket_ShortcutLoginRequest : BasePacket {
    /*
     public String token;
     public String terminalType;
     public String terminalPlatform;
     public String publishChannel;
     public String version;
     */
    
    std::string token;              //token
    std::string terminalType;       //终端平台类型
    std::string terminalPlatform;   //终端型号
    std::string publishChannel;     //发布渠道标识
    std::string version;            //客户端版本
};

NET_APPEND(NetPacket_ShortcutLoginRequest)
{
    lht << rht._packhead
        << rht._packtype
        << rht._packindex
        << rht.token
        << rht.terminalType
        << rht.terminalPlatform
        << rht.publishChannel
        << rht.version;
    return lht;
};

struct NetPacket_ShortcutLoginResponse : BasePacket {
    /*
     public String username;
     public String token;
     @Comment("类型，1：正式账号，2：游客账号")
     public byte accountType;
     @Comment("账号是否绑定手机")
     public boolean accountIsBoundMsisdn;
     
     public byte result = RESULT_OF_SUCCESS;
     */
    std::string username;
    std::string token;
    int8 accountType;
    int8 accountIsBoundMsisdn;
    int8 result;
};

NET_READ(NetPacket_ShortcutLoginResponse)
{
    lht >> rht._packhead
        >> rht._packtype
        >> rht._packindex
        >> rht.username
        >> rht.token
        >> rht.accountType
        >> rht.accountIsBoundMsisdn
        >> rht.result;
    return lht;
};

/// 测试1的网络数据包定义
struct NetPacket_Test_POD
{
	int		nIndex;
	char	arrMessage[512];
};

/// 测试2的网络数据包定义
struct NetPacket_Test_Serialize
{
	int			nIndex;
	std::string	strMessage;
};
NET_APPEND(NetPacket_Test_Serialize)
{
	lht << rht.nIndex
		<< rht.strMessage;
	return lht;
};
NET_READ(NetPacket_Test_Serialize)
{
	lht >> rht.nIndex
		>> rht.strMessage;
	return lht;
};

