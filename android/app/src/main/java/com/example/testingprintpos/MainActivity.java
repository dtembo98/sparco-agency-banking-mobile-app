package com.example.testingprintpos;
import androidx.annotation.NonNull;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Message;
import android.os.RemoteException;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;
import wangpos.sdk4.libbasebinder.Printer;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;


public class MainActivity extends FlutterActivity  {

    private static final String TAG = "CommonPrint";
    private Printer mPrinter;
    private boolean bloop = false;
    private boolean isRunning = false;
    private int command = 0;
    private int print_type = 0;
    String res;
    int batteryLevel = -1;
    private static final String CHANNEL = "samples.flutter.dev/battery";

    @Override
    protected void onStart() {
        super.onStart();
        new Thread(){
            @Override
            public void run() {
                mPrinter = new Printer(getApplicationContext());
                try {
                    mPrinter.setPrintType(print_type);
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
            }
        }.start();
    }
//    private int getBatteryLevel() {
//    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
//      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
//      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
//
//    } else {
//      Intent intent = new ContextWrapper(getApplicationContext()).
//          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
//      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
//          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
//    }
//
//    return batteryLevel;
//  }
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
  GeneratedPluginRegistrant.registerWith(flutterEngine);
//   FlutterView view = getFlutterView();

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            // Note: this method is invoked on the main thread.
            // TODO
            if (call.method.equals("printData")) {
                command =  1;
                String token = "343435223432242342";
                if (!isRunning) {
                    Map<String,Object> receiptData= call.arguments();
                    new PrintThread(
                            receiptData.get("agent"),
                            receiptData.get("token"),
                            receiptData.get("amount"),
                            receiptData.get("units"),
                            receiptData.get("receipient"),
                            receiptData.get("meter"),
                            receiptData.get("txnTime"),
                            receiptData.get("txnDate")
                    ).start();
                    result.success(receiptData);
                }else
                {
                    result.error("UNAVAILABLE", "error printing receipt", null);
                }

              }   else {
                result.notImplemented();
            }
          }
        );
        
        
  }

    Handler mHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what){
                case 1:
                    ResultInfo msgInfo = (ResultInfo) msg.obj;
                    String result = msgInfo.type +" "+msgInfo.context +"\n"+
                            msgInfo.type+" return code " + msgInfo.code +"\n";
                    res = result;
                    break;
                case 10:

                    break;
            }


        }
    };

    class ResultInfo{
        String context;
        int code;
        String type;
    }

    private void testPrintLaguage(){
        try {
            mPrinter.printString("A number of national languages, for example：", 22, Printer.Align.LEFT, true, false);
            //法语
            mPrinter.printString("Bonjour Comment ça va Au revoir!", 30, Printer.Align.CENTER, true, false);
            //德语
            mPrinter.printString("Guten Tag Wie geht's?Auf Wiedersehen.", 30, Printer.Align.CENTER, true, false);
            //阿拉伯语
            mPrinter.printString(" في متصفحه. عبارة اصفحة ارئيسية تستخدم أيضاً إشا", 30, Printer.Align.CENTER, true, false);
            //乌克兰语
            mPrinter.printString("Доброго дня Як справи? Бувайте!", 30, Printer.Align.CENTER, true, false);
            //格鲁吉亚语
            mPrinter.printString("გამარჯობა（gamarǰoba）კარგად（kargad）", 30, Printer.Align.CENTER, true, false);
            //韩语
            mPrinter.printString("안녕하세요 잘 지내세요 안녕히 가세요!", 30, Printer.Align.CENTER, true, false);
            //日语
            mPrinter.printString("こんにちは お元気ですか またね！", 30, Printer.Align.CENTER, true, false);
            //印尼语
            mPrinter.printString("Selamat Pagi/Siang Apa kabar? Sampai nanti!", 30, Printer.Align.CENTER, true, false);
            //南非荷兰语
            mPrinter.printString("Goeie dag Hoe gaan dit? Totsiens!", 30, Printer.Align.CENTER, true, false);
            //....
        } catch (RemoteException e){
            e.printStackTrace();
        }

    }

    private void testPrintString(String agent, String token, String meter, String txnTime, String units, String receipient, String amount, String txnDate){
        try {
            //default content print
            mPrinter.printStringExt("BROADPAY ZAMBIA LTD ", 0, 0f, 2.0f, Printer.Font.DEFAULT_BOLD, 50, Printer.Align.CENTER, false, false, false);
            mPrinter.printString("-------------AGENT--------------", 35, Printer.Align.CENTER, true, false);
            mPrinter.printString(agent, 33, Printer.Align.CENTER, true, false);
            mPrinter.printString("--------------------------------------------", 30, Printer.Align.CENTER, false, false);
            mPrinter.printString("Zesco Electricity Token", 35, Printer.Align.CENTER, true, false);
            mPrinter.printString(token, 35, Printer.Align.CENTER, false, false);
            mPrinter.printString("--------------------------------------------", 30, Printer.Align.CENTER, false, false);
            mPrinter.print2StringInLine("Meter N0 : ", meter, 1.0f, Printer.Font.DEFAULT, 30, Printer.Align.LEFT, false, false, false);
            mPrinter.print2StringInLine("Amount : ", amount, 1.0f, Printer.Font.DEFAULT, 30, Printer.Align.LEFT, false, false, false);
            mPrinter.print2StringInLine("Units:  ", units, 1.0f, Printer.Font.DEFAULT, 30, Printer.Align.LEFT, false, false, false);
            mPrinter.printString("--------------------------------------------", 25, Printer.Align.CENTER, false, false);
            mPrinter.print2StringInLine("Receipient", receipient, 1.0f, Printer.Font.DEFAULT, 27, Printer.Align.LEFT, false, false, false);
            mPrinter.print2StringInLine("Date:", txnDate, 1.0f, Printer.Font.DEFAULT, 27, Printer.Align.LEFT, false, false, false);
            mPrinter.print2StringInLine("Time:", txnTime, 1.0f, Printer.Font.DEFAULT, 27, Printer.Align.LEFT, false, false, false);

            mPrinter.printString("--------------------------------------------", 30, Printer.Align.CENTER, false, false);
            mPrinter.printString("Thank you", 40, Printer.Align.CENTER, false, false);

        } catch (RemoteException e){
            e.printStackTrace();
        }

    }

    private void testPrintImage(int result){
        try {
            InputStream inputStream = getAssets().open("google_icon.jpg");
            Bitmap bitmap =  BitmapFactory.decodeStream(inputStream);
            result = mPrinter.printImage(bitmap, 384, Printer.Align.CENTER);
            bitmap.recycle();
        }catch (IOException e){
            e.printStackTrace();
        }catch (RemoteException ex){
            ex.printStackTrace();
        }
    }

    private void testPrintImageBase(int result){
        try {
            InputStream inputStream = getAssets().open("google_icon.jpg");
            Bitmap bitmap =  BitmapFactory.decodeStream(inputStream);
            result = mPrinter.printImageBase(bitmap, 100, 100, Printer.Align.LEFT, 0);
            bitmap.recycle();
        }catch (IOException e){
            e.printStackTrace();
        }catch (RemoteException ex){
            ex.printStackTrace();
        }
    }

    private void initConnection(){
        int result = -1;
        try {
            result = mPrinter.printInit();
            Log.v(TAG, "init Print result:" + result);
            ResultInfo msgInfo = new ResultInfo();
            msgInfo.code = result;
            if(result == 0){
                msgInfo.context = "Success";
                msgInfo.type = "Connection Print";
            }else{
                msgInfo.context = "Failed";
                msgInfo.type = "Connection Print";
            }
            Message msg = new Message();
            msg.what = 1;
            msg.obj = msgInfo;
            mHandler.sendMessage(msg);
            mPrinter.clearPrintDataCache();
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    private void CheckBTStatus(){
        try {
            int[] status = new int[1];
            mPrinter.getPrinterStatus(status);
            Log.e(TAG,"status is "+status[0]);
            ResultInfo msgInfo = new ResultInfo();
            msgInfo.code = status[0];
            if(status[0] == 0){
                msgInfo.context = "Success";
                msgInfo.type = "Printer status";
            }else{
                msgInfo.context = "Failed";
                msgInfo.type = "Printer status";
            }
            Message msg = new Message();
            msg.what = 1;
            msg.obj = msgInfo;
            mHandler.sendMessage(msg);
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    private void blueToothPrint(String agent,String token,String meter,String txnDate,String txnTime,String units,String receipient,String amount){
        int result = -1;
        try {
           
            // Print text
            testPrintString(agent,token,meter,txnTime,units,receipient,amount, txnDate);
            //laguage print
            // testPrintLaguage();
            //print end reserve height
            result = mPrinter.printPaper(100);
            ResultInfo msgInfo = new ResultInfo();
            msgInfo.code = result;
            if(result == 0){
                msgInfo.context = "Printing...";
                msgInfo.type = "Print content";
            }else{
                msgInfo.context = "Function Call failed";
                msgInfo.type = "Print content";
            }
            Message msg = new Message();
            msg.what = 1;
            msg.obj = msgInfo;
            mHandler.sendMessage(msg);
//            disConnectionBT();
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    private void disConnectionBT(){
        int result = -1;
        try {
            result =  mPrinter.printFinish();
            Log.v(TAG, "printFinish result:" + result);
            ResultInfo msgInfo = new ResultInfo();
            msgInfo.code = result;
            if(result == 0){
                msgInfo.context = "Success";
                msgInfo.type = "disconnection Print";
            }else{
                msgInfo.context = "Failed";
                msgInfo.type = "disconnection Print";
            }
            Message msg = new Message();
            msg.what = 1;
            msg.obj = msgInfo;
            mHandler.sendMessage(msg);
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    public  class PrintThread extends Thread {
         String txnDate;
        String agent;
String token;
String meter;
String receipient;
String txnTime;
String units;
String amount;

        public PrintThread(Object agent, Object token, Object amount, Object units, Object receipient, Object meter, Object txnTime, Object txnDate) {
            this.agent= (String) agent;
            this.token = (String) token;
            this.meter= (String)  meter;
            this.txnTime = (String)  txnTime;
            this.txnDate = (String) txnDate;
            this.units = (String)  units;
            this.receipient = (String) receipient;
            this. amount = (String) amount;
        }

        @Override
        public void run () {
            isRunning = true;
            do {
                switch (command){
                    case 0:
                        initConnection();
                        break;
                    case 1:
                        blueToothPrint(this.agent,this.token,this.meter,this.txnDate,this.txnTime,this.units,this.receipient,this. amount);
                        break;
                    case 2:
                        CheckBTStatus();
                        break;
                    case 3:
                        disConnectionBT();
                        break;
                    default:

                        break;
                }
            } while (bloop);
            isRunning = false;
        }
    }
}
  

