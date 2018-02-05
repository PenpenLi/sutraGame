LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

$(call import-add-path,$(LOCAL_PATH)/../../../../cocos2d-x)
$(call import-add-path,$(LOCAL_PATH)/../../../../cocos2d-x/external)
$(call import-add-path,$(LOCAL_PATH)/../../../../cocos2d-x/cocos)
$(call import-add-path,$(LOCAL_PATH)/../../../../cocos2d-x/game)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

MY_CPP_LIST := $(wildcard $(LOCAL_PATH)/*.cpp) \
       		   $(wildcard $(LOCAL_PATH)/../../../Classes/MacAddress/*.cpp) \
       		   $(wildcard $(LOCAL_PATH)/../../../Classes/net/*.cpp) \
       		   $(wildcard $(LOCAL_PATH)/../../../Classes/*.cpp)	\
		   hellolua/main.cpp	
       		   

LOCAL_SRC_FILES := $(MY_CPP_LIST:$(LOCAL_PATH)/%=%)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes \
					$(LOCAL_PATH)/../../../Classes/MacAddress \
					$(LOCAL_PATH)/../../../Classes/net	\
					$(LOCAL_PATH)/../../../../cocos2d-x/external \
					$(LOCAL_PATH)/../../../../cocos2d-x/tools/simulator/libsimulator/lib \
					$(LOCAL_PATH)/../../../../cocos2d-x/tools/simulator/libsimulator/lib/protobuf-lite	\
					$(LOCAL_PATH)/../../../../cocos2d-x/cocos/base	\
					$(LOCAL_PATH)/../../../../cocos2d-x/cocos/game	\
					$(LOCAL_PATH)/../../../../cocos2d-x/cocos/scripting/lua-bindings/manual

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += cocos2d_simulator_static

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,tools/simulator/libsimulator/proj.android)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
