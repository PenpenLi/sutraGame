package org.cocos2dx.lua;

import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.provider.Settings;
import android.telephony.TelephonyManager;

import org.cocos2dx.lib.Cocos2dxHelper;
import java.io.InputStreamReader;
import android.view.KeyEvent;
import android.view.WindowManager;



import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;


/**
 * Created by Administrator on 2016/9/28.
 */
public class AppUtils {
    public static final String NET_TYPE_MOBILE = "mobile";
    public static final String NET_TYPE_WIFI = "wifi";
    public static final String NET_TYPE_UNKNOW = "unknow";
    private static Context context = null;

    public static void init(Context mContext){
        context = mContext;
    }

    /**
     * 获取手机网络类型（移动网络orWifi网络）
     * @return
     */
    public static String getNetType() {
        ConnectivityManager connectMgr = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo info = connectMgr.getActiveNetworkInfo();
        if (info != null) {
            int type = info.getType();
            if (type == ConnectivityManager.TYPE_WIFI) {
                return NET_TYPE_WIFI;
            } else if (type == ConnectivityManager.TYPE_MOBILE) {
                return NET_TYPE_MOBILE;
            }
        }
        return NET_TYPE_UNKNOW;
    }

    /**
     * 得到当前包的versionCode
     * @return String
     */
    public static String getVersionCode() {
        String pkName = Cocos2dxHelper.getActivity().getPackageName();
        try{
            return String.valueOf(Cocos2dxHelper.getActivity().getPackageManager().getPackageInfo(pkName, 0).versionCode);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return String.valueOf(0);
    }

    /**
     * 得到设备ID
     * @return 设备ID
     *
     * */
    public static String getDeviceID()
    {
        //imei

        TelephonyManager telephonyManager = (TelephonyManager)AppActivity.g_AppActivity.getSystemService(Context.TELEPHONY_SERVICE);
        String deviceid = telephonyManager.getDeviceId();
        if (deviceid == null)
            deviceid = "";
        return deviceid;//小米pad這裏會崩
    }
    public static String getSubscriberId()
    {

        TelephonyManager telephonyManager = (TelephonyManager) AppActivity.g_AppActivity.getSystemService(Context.TELEPHONY_SERVICE);
        String IMSI = telephonyManager.getSubscriberId();
        if (IMSI == null)
            IMSI = "";
        return IMSI;


    }

    public static String getSource()
    {
        String source = "";// getString(R.string.app_source);
        return source;
    }

    public static String getDeviceClientId()
    {
        String m_szAndroidID = Settings.Secure.getString(AppActivity.g_AppActivity.getContentResolver(), Settings.Secure.ANDROID_ID);

        String m_szDevIDShort = "35" + //we make this look like a valid IMEI
                Build.BOARD.length()%10 +
                Build.BRAND.length()%10 +
                Build.CPU_ABI.length()%10 +
                Build.DEVICE.length()%10 +
                Build.DISPLAY.length()%10 +
                Build.HOST.length()%10 +
                Build.ID.length()%10 +
                Build.MANUFACTURER.length()%10 +
                Build.MODEL.length()%10 +
                Build.PRODUCT.length()%10 +
                Build.TAGS.length()%10 +
                Build.TYPE.length()%10 +
                Build.USER.length()%10 ;
        String m_szImei = getDeviceID();

        WifiManager wm = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
        String m_szWLANMAC = wm.getConnectionInfo().getMacAddress();

        BluetoothAdapter m_BluetoothAdapter = null; // Local Bluetooth adapter
        m_BluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        String m_szBTMAC = m_BluetoothAdapter.getAddress();



        String m_szLongID = m_szImei + m_szDevIDShort
                + m_szAndroidID+ m_szWLANMAC + m_szBTMAC;
// compute md5
        MessageDigest m = null;
        try {
            m = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        m.update(m_szLongID.getBytes(),0,m_szLongID.length());
// get md5 bytes
        byte p_md5Data[] = m.digest();
// create a hex string
        String szUniqueID = new String();
        for (int i=0;i<p_md5Data.length;i++) {
            int b =  (0xFF & p_md5Data[i]);
// if it is a single digit, make sure it have 0 in front (proper padding)
            if (b <= 0xF)
                szUniqueID+="0";
// add number to string
            szUniqueID+=Integer.toHexString(b);
        }   // hex string to uppercase
        szUniqueID = szUniqueID.toUpperCase();

        return szUniqueID;
    }
    //獲取包名
    public static String getPackageName()
    {
        return AppActivity.g_AppActivity.getPackageName();
    }

    public static String getOsVerSionName() {
        String versionString = android.os.Build.VERSION.RELEASE;
        return versionString;
    }

    public static String getDeviceName() {
        StringBuffer temp = new StringBuffer();
        temp.append(android.os.Build.MANUFACTURER);
        temp.append(" ");
        temp.append(android.os.Build.MODEL);
        return temp.toString();
    }

}
