class UserData {
  String fname;
  String lname;
  String phone;
  String email;
  String nrc;
  String passport;
  String address;
  bool isAdmin;
  bool isAgent;
  int ledgerBalance;
  int float;
  bool isError;
  String msg;
  String status;

  UserData(
      {this.fname,
      this.float,
      this.msg,
      this.lname,
      this.phone,
      this.ledgerBalance,
      this.isError});

  UserData.fromJson(Map json) {
    this.fname = json["data"]["firstname"];
    this.float = json["data"]["float"];
    this.lname = json["data"]["lastname"];
    this.phone = json["data"]["mobile_wallet"];
    this.email = json["data"]["email"];
    this.nrc = json["data"]["nrc"];
    this.passport = json["data"]["passport"];
    this.address = json["data"]["address"];
    this.isAdmin = json["data"]["is_admin"];
    this.isAgent = json["data"]["is_agent"];
    this.ledgerBalance = json["data"]["ledger_balance"];
    this.isError = json["is_error"];
    this.msg = json["msg"];
    this.status = json["status"];
  }
}
