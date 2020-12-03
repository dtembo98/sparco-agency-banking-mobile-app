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
  double ledgerBalance;
  bool isError;
  String msg;
  String status;

  UserData(
      {this.fname, this.lname, this.phone, this.ledgerBalance, this.isError});

  UserData.fromJson(Map json) {
    this.fname = json["user"]["first_name"];
    this.lname = json["user"]["last_name"];
    this.phone = json["user"]["phone"];
    this.email = json["user"]["email"];
    this.nrc = json["user"]["nrc"];
    this.passport = json["user"]["passport"];
    this.address = json["user"]["address"];
    this.isAdmin = json["user"]["is_admin"];
    this.isAgent = json["user"]["is_agent"];
    this.ledgerBalance = json["user"]["ledger_balance"];
    this.isError = json["is_error"];
    this.msg = json["msg"];
    this.status = json["status"];
  }
}
