// package com.example.testingprintpos.print;

// import android.graphics.Bitmap;
// import android.graphics.BitmapFactory;
// import android.os.Bundle;
// import android.os.Handler;
// import android.os.Message;
// import android.os.RemoteException;
// import android.support.v7.app.AppCompatActivity;
// import android.util.Log;
// import android.view.View;
// import android.widget.TextView;

// import com.example.testingprintpos.R;

// import java.io.IOException;
// import java.io.InputStream;
// import java.util.ArrayList;

// import wangpos.sdk4.base.ICommonCallback;
// import wangpos.sdk4.libbasebinder.Printer;
// import wangpos.sdk4.libbasebinder.Printer.Align;
// import wangpos.sdk4.libbasebinder.RspCode;

// public class BTPrinting extends AppCompatActivity {
//     private static final String TAG = "BTPrinting";
//     private System mSystem;
//     private Printer mPrinter;
//     private TextView tv_info;
//     private boolean bloop = false;
//     private boolean isRunning = false;
//     private int command = 0; // 0 初始化 1 打印 2 获取状态 3 断开

//     @Override
//     protected void onCreate(Bundle savedInstanceState) {
//         super.onCreate(savedInstanceState);
//         setContentView(R.layout.activity_btprinter);

//         new Thread(){
//             @Override
//             public void run() {
//                 mPrinter = new Printer(getApplicationContext());
//                 try {
//                     mPrinter.setPrintType(1);
//                     mPrinter.setPrintPaperType(1);
//                 } catch (RemoteException e) {
//                     e.printStackTrace();
//                 }
//             }
//         }.start();
//         tv_info = (TextView) findViewById(R.id.tvContext);


//         findViewById(R.id.btnInit).setOnClickListener(new View.OnClickListener() {
//             @Override
//             public void onClick(View v) {
//                 command = 0;
//                 if (isRunning == false){
//                     new PrintThread().start();
//                     tv_info.setText("");
//                 }else{
//                     tv_info.append("is Running"+"\n");
//                 }
//             }
//         });
//         findViewById(R.id.btnPrint).setOnClickListener(new View.OnClickListener() {
//             @Override
//             public void onClick(View v) {
//                 command = 1;
//                 if (isRunning == false){
//                     new PrintThread().start();
//                     tv_info.setText("");
//                 }else{
//                     tv_info.append("is Running"+"\n");
//                 }
//             }
//         });
//         findViewById(R.id.btnCheck).setOnClickListener(new View.OnClickListener() {
//             @Override
//             public void onClick(View v) {
//                 command = 2;
//                 if (isRunning == false){
//                     new PrintThread().start();
//                     tv_info.setText("");
//                 }else{
//                     tv_info.append("is Running"+"\n");
//                 }
//             }
//         });
//         findViewById(R.id.btnFinish).setOnClickListener(new View.OnClickListener() {
//             @Override
//             public void onClick(View v) {
//                 command = 3;
//                 if (isRunning == false){
//                     new PrintThread().start();
//                     tv_info.setText("");
//                 }else{
//                     tv_info.append("is Running"+"\n");
//                 }

//             }
//         });


//         findViewById(R.id.buttonexitprint).setOnClickListener(new View.OnClickListener() {
//             @Override
//             public void onClick(View v) {
//                 bloop = false;
//                 finish();
//             }
//         });
//     }

//     Handler mHandler = new Handler(){
//         @Override
//         public void handleMessage(Message msg) {
//             super.handleMessage(msg);
//             switch (msg.what){
//                 case 1:
//                     ResultInfo msgInfo = (ResultInfo) msg.obj;
//                     String result = msgInfo.type +" "+msgInfo.context +"\n"+
//                             msgInfo.type+" return code " + msgInfo.code +"\n";
//                     tv_info.append(result);
//                     break;
//                 case 10:

//                     break;
//             }


//         }
//     };

//     class ResultInfo{
//         String context;
//         int code;
//         String type;
//     }

//     private void testPrintLaguage(int result){
//         try {
//             result = mPrinter.printString("A number of national languages, for example：", 22, Align.LEFT, true, false);
//             //法语
//             result = mPrinter.printString("Bonjour Comment ça va Au revoir!", 25, Align.CENTER, true, false);
//             //德语
//             result = mPrinter.printString("Guten Tag Wie geht's?Auf Wiedersehen.", 25, Align.CENTER, true, false);
//             //阿拉伯语
//             result = mPrinter.printString(" في متصفحه. عبارة اصفحة ارئيسية تستخدم أيضاً إشا", 25, Align.CENTER, true, false);
//             //乌克兰语
//             result = mPrinter.printString("Доброго дня Як справи? Бувайте!", 25, Align.CENTER, true, false);
//             //格鲁吉亚语
//             result = mPrinter.printString("გამარჯობა（gamarǰoba）კარგად（kargad）", 25, Align.CENTER, true, false);
//             //韩语
//             result = mPrinter.printString("안녕하세요 잘 지내세요 안녕히 가세요!", 25, Align.CENTER, true, false);
//             //日语
//             result = mPrinter.printString("こんにちは お元気ですか またね！", 25, Align.CENTER, true, false);
//             //印尼语
//             result = mPrinter.printString("Selamat Pagi/Siang Apa kabar? Sampai nanti!", 25, Align.CENTER, true, false);
//             //南非荷兰语
//             result = mPrinter.printString("Goeie dag Hoe gaan dit? Totsiens!", 25, Align.CENTER, true, false);
//             //....
//         } catch (RemoteException e){
//             e.printStackTrace();
//         }

//     }

//     private void testPrintString(int result){
//         try {
//             //default content print
//             result = mPrinter.printString("www.wiseasy.com", 25, Align.CENTER, true, false);
//             result = mPrinter.printString("北京微智全景信息技术有限公司",25,Align.CENTER,false,false);
//             result = mPrinter.printString("  ", 30, Align.CENTER, false,false);
//             result = mPrinter.printString("--------------------------------------------", 30, Align.CENTER, false, false);
//             result = mPrinter.printString("Meal Package:KFC $100 coupons", 25, Align.LEFT, false, false);
//             result = mPrinter.printString("Selling Price:$90", 25, Align.LEFT, false, false);
//             result = mPrinter.printString("Merchant Name:KFC（ZS Park）", 25, Align.LEFT, false, false);
//             result = mPrinter.printString("Payment Time:17/3/29 9:27", 25, Align.LEFT, false, false);
//             result = mPrinter.printString("--------------------------------------------", 30, Align.CENTER, false, false);
//             result = mPrinter.printString("NO. of Coupons:5", 25, Align.LEFT, false, false);
//             result = mPrinter.printString("Total Amount:$450", 25, Align.LEFT, false,false);
//             result = mPrinter.printString("SN:1234 4567 4565", 25, Align.LEFT, false, false);
//             //default content is too long to wrap
//             result = mPrinter.printString("the content is too long to wrap the content is too long to wrap", 25, Align.LEFT, false, false);
//             //font style print
//             result = mPrinter.printStringExt("Default Font",0,0f,2.0f, Printer.Font.DEFAULT,30, Align.CENTER,false, false, false);
//             result = mPrinter.printStringExt("Default Bold Font ", 0,0f,2.0f, Printer.Font.DEFAULT_BOLD, 30,Align.LEFT,false,false,false);
//             result = mPrinter.printStringExt("Monospace Font ", 0,0f,2.0f, Printer.Font.MONOSPACE, 30,Align.LEFT,false,false,false);
//             result = mPrinter.printStringExt("Sans Serif Font ", 0,0f,2.0f, Printer.Font.SANS_SERIF, 30,Align.LEFT,false,false,false);
//             result = mPrinter.printStringExt("Serif Font ", 0,0f,2.0f, Printer.Font.SERIF, 30,Align.RIGHT,false,false,false);
//             //two content left and right in one line
//             result = mPrinter.print2StringInLine("left","right",1.0f,Printer.Font.DEFAULT,25,Align.LEFT,false, false, false);

//         } catch (RemoteException e){
//             e.printStackTrace();
//         }

//     }

//     private void testPrintImage(int result){
//         try {
//             InputStream inputStream = getAssets().open("google_icon.jpg");
//             Bitmap bitmap =  BitmapFactory.decodeStream(inputStream);
//             result = mPrinter.printImage(bitmap, 384, Align.CENTER);
//             bitmap.recycle();
//         }catch (IOException e){
//             e.printStackTrace();
//         }catch (RemoteException ex){
//             ex.printStackTrace();
//         }
//     }

//     private void testPrintImageBase(int result){
//         try {
//             InputStream inputStream = getAssets().open("google_icon.jpg");
//             Bitmap bitmap =  BitmapFactory.decodeStream(inputStream);
//             result = mPrinter.printImageBase(bitmap, 100, 100, Align.LEFT, 0);
//             bitmap.recycle();
//         }catch (IOException e){
//             e.printStackTrace();
//         }catch (RemoteException ex){
//             ex.printStackTrace();
//         }
//     }
//     private ICommonCallback icallback = new ICommonCallback.Stub() {
//         @Override
//         public int CommonCallback(int code) throws RemoteException {
//             Log.e("CommonCallback","code is" + code);
//             ResultInfo msgInfo = new ResultInfo();
//             msgInfo.code = code;
//             msgInfo.context = ""+code;
//             msgInfo.type = "CallBace Code";
//             switch (code){
//                 case 10://缓存数据打印结束
//                     msgInfo.context = "Print end";
//                     msgInfo.type = "Print content";
//                     break;
//                 case 0://打印机正常
//                     msgInfo.context = "normal";
//                     msgInfo.type = "get Printer status";
//                     break;
//                 case 2://打印机缺纸
//                     msgInfo.context = "Out of paper";
//                     msgInfo.type = "get Printer status";
//                     break;
//             }
//             Message msg = new Message();
//             msg.what = 1;
//             msg.obj = msgInfo;
//             mHandler.sendMessage(msg);
//             return 0;
//         }
//     };

//     public byte[] getESCData(){
//         ArrayList<byte[]> data = new ArrayList<byte[]>();
//                     data.add(BTPrinterCommand.RESET);
//                     data.add(BTPrinterCommand.LINE_SPACING_DEFAULT);
//                     data.add(BTPrinterCommand.ALIGN_CENTER);
//                     data.add(BTPrinterCommand.getdata("微智智能终端 签购单"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("POS SALES SLIP"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("--------------------------------"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("MERCHANT NAME"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("商户名称","CUPTEST")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("MERCHANT NO"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("商户编号","000000000000001")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("TERMINAL NO"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("终端编号","98765432")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("操作员号(OPERATOR)","01")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("卡号(CARD NUMBER)","4761 73** **** 0010")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("--------------------------------"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("发卡行号(ISS NO)","14334")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("收单行号(ACQ NO)","54546")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("交易类别(TXN TYPE)","GOODS/Purchase")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("有效期(EXP.DATE)","2020/12")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("批次号(BATCH NO)","000002")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("凭证号(VOUCHER NO)","000093")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("授权码(AUTH NO)","98765432")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("日期/时间(DATE/TIME)","2017/10/25 10:22:08")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("金额(AMOUT)","RMB 5.00")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("小费(TIPS)","RMB 0.00")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata(BTPrinterCommand.printTwoData("总计(TOTAL)","RMB 5.00")));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("--------------------------------"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.ALIGN_LEFT);
//                     data.add(BTPrinterCommand.getdata("备注:"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("REFERENCE:"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("ARQC: 882D8427A268E214"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("AID: A0000000031010"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("TVR: 8080000800"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("TSI: 6800"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("ATC: 0001"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("应用标签: VISACREDIT"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("首选名称: VISA DebitCredit"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.ALIGN_CENTER);
//                     data.add(BTPrinterCommand.getdata("--------------------------------"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("本人确认以上交易，同意将其记入本卡帐户"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("I ACKNOWLEDGE SATISFACTORY"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("I RECEIPT OF RELATIVE GOODS/SERVICES"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("--------------------------------"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.getdata("商户存根  MERCHANT COPY"));
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.printLine);
//                     data.add(BTPrinterCommand.printLine);
//         return BTPrinterCommand.setCommand(data);


//     }

//     private void initConnection(){
//         int result = -1;
//         try {
//             result = mPrinter.printInit();
//             Log.v(TAG, "initBlueToothPrint result:" + result);
//             ResultInfo msgInfo = new ResultInfo();
//             msgInfo.code = result;
//             if(result == 0){
//                 msgInfo.context = "Success";
//                 msgInfo.type = "Connection Print";
//             }else{
//                 msgInfo.context = "Failed";
//                 msgInfo.type = "Connection Print";
//             }
//             Message msg = new Message();
//             msg.what = 1;
//             msg.obj = msgInfo;
//             mHandler.sendMessage(msg);
//             mPrinter.clearPrintDataCache();
//         } catch (RemoteException e) {
//             e.printStackTrace();
//         }
//     }

//     private void CheckBTStatus(){
//         try {
//             int[] status = new int[1];
//             mPrinter.getPrinterStatus(status);
//             Log.e("USBPrint","status is "+status[0]);
//             ResultInfo msgInfo = new ResultInfo();
//             msgInfo.code = status[0];
//             if(status[0] == 0){
//                 msgInfo.context = "Success";
//                 msgInfo.type = "Printer status";
//             }else{
//                 msgInfo.context = "Failed";
//                 msgInfo.type = "Printer status";
//             }
//             Message msg = new Message();
//             msg.what = 1;
//             msg.obj = msgInfo;
//             mHandler.sendMessage(msg);
//         } catch (RemoteException e) {
//             e.printStackTrace();
//         }
//     }

//     private void blueToothPrint(){
//         int result = -1;
//         try {
//             // Print Image (such as logo)
//             testPrintImageBase(result);
// //            // Print text
//             testPrintString(result);
//             // print bar_Code
//             result = mPrinter.printBarCodeBase("1234567890abcdefg", Printer.BarcodeType.CODE_128, Printer.BarcodeWidth.LARGE, 50, 20);
// //            //print QR_Code
//             result = mPrinter.printQRCode("http://www.wangpos.com");
//             //laguage print
//             testPrintLaguage(result);
//             //print end reserve height
//             result = mPrinter.printPaper(100);
//             ResultInfo msgInfo = new ResultInfo();
//             msgInfo.code = result;
//             if(result == 0){
//                 msgInfo.context = "Print End.";
//                 msgInfo.type = "Print content";
//             }else{
//                 msgInfo.context = "Function Call failed";
//                 msgInfo.type = "Print content";
//             }
//             Message msg = new Message();
//             msg.what = 1;
//             msg.obj = msgInfo;
//             mHandler.sendMessage(msg);
//         } catch (RemoteException e) {
//             e.printStackTrace();
//         }
//     }

//     private void disConnectionBT(){
//         int result = -1;
//         try {
//             result =  mPrinter.printFinish();
//             Log.v(TAG, "finishBlueToothPrint result:" + result);
//             ResultInfo msgInfo = new ResultInfo();
//             msgInfo.code = result;
//             if(result == 0){
//                 msgInfo.context = "Success";
//                 msgInfo.type = "disconnection BTPrint";
//             }else{
//                 msgInfo.context = "Failed";
//                 msgInfo.type = "disconnection BTPrint";
//             }
//             Message msg = new Message();
//             msg.what = 1;
//             msg.obj = msgInfo;
//             mHandler.sendMessage(msg);
//         } catch (RemoteException e) {
//             e.printStackTrace();
//         }
//     }

//     /**
//      * PrinterControl(int command,请求状态，必需域	1	HEX1	0x01 开始打印（打开打印机）
//      0x02 打印中，用于数据传输
//      0x03 走纸
//      0x0A 结束打印（关闭打印机）
//      * int length,打印数据长度/走纸长度，必需域	N	HEX2	最大1024，高字节在前，开始和结束时如果无数据，传0
//      * byte[] data)打印点阵数据（可选域）	N	HEX	开始和结束也可以传输数据
//      */
//     public class PrintThread extends Thread {
//         @Override
//         public void run () {
//             isRunning = true;
//             do {
//                 switch (command){
//                     case 0:
//                         initConnection();
//                         break;
//                     case 1:
//                         blueToothPrint();
//                         break;
//                     case 2:
//                         CheckBTStatus();
//                         break;
//                     case 3:
//                         disConnectionBT();
//                         break;
//                     default:

//                         break;
//                 }
//             } while (bloop);
//             isRunning = false;
//         }
//     }
// }
