import 'package:hive/hive.dart';
// part "txn_data.g.dart";

// @HiveType(typeId: 0)
class TxnData {
  // @HiveField(0)
  int txnId;
  // @HiveField(1)
  String service;
  // @HiveField(2)
  String msisdn;
  // @HiveField(3)
  String serviceProvider;
  // @HiveField(4)
  String serviceProviderRef;
  // @HiveField(5)
  double amount;
  // @HiveField(6)
  String desc;
  // @HiveField(9)
  double agentsCommission;
  // @HiveField(10)
  double broadpaysCommission;
  // @HiveField(11)
  String status;
  // @HiveField(12)
  bool isError;
  // @HiveField(13)
  String token;
  // @HiveField(14)
  String meterNumber;
  // @HiveField(15)
  String msg;
  // @HiveField(16)
  String txnDateTime;
  // @HiveField(18)
  String sender;
  // @HiveField(19)
  String recipient;
  // @HiveField(20)
  String created;
  // @HiveField(21)
  String customerName;

  TxnData({
    this.txnId,
    this.service,
    this.msisdn,
    this.serviceProvider,
    this.serviceProviderRef,
    this.amount,
    this.desc,
    this.agentsCommission,
    this.broadpaysCommission,
    this.status,
    this.token,
    this.meterNumber,
    this.customerName,
    this.isError = false,
    this.msg,
    this.txnDateTime,
    this.sender,
    this.recipient,
    this.created,
  });

  factory TxnData.fromJson(Map json) {
    return TxnData(
        txnId: json["id"],
        service: json["service"],
        msisdn: json["msisdn"],
        serviceProvider: json["service_provider"],
        serviceProviderRef: json["service_provider_ref"],
        amount: json["total_amount"],
        desc: json["desc"],
        agentsCommission: json["agent_commission"],
        broadpaysCommission: json["bp_commission"],
        status: json["status"],
        isError: json["is_error"],
        token: json["token"],
        meterNumber: json["meter_number"],
        msg: json["msg"],
        txnDateTime: json["created"],
        sender: json["sender"],
        recipient: json["recipient"],
        created: json["created"],
        customerName: json["customerName"]);
  }
}
