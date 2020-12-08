class UserData {
  dynamic fname;
  dynamic lname;
  dynamic phone;
  dynamic email;
  dynamic nrc;
  dynamic passport;
  dynamic address;
  dynamic isAdmin;
  dynamic isAgent;
  dynamic ledgerBalance;
  dynamic float;
  dynamic isError;
  dynamic msg;
  dynamic status;

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
