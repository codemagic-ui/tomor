class UserOrderModel {
  var strItemCustomerId;
  var strItemOrderId;
  var strItemImageUrl = "";
  var strItemName;
  var strItemOrderNumber;
  var strItemDateAndTime;
  var strItemOrderStatus = "";
  var strItemPrice = "";

  UserOrderModel(
      {this.strItemCustomerId,
      this.strItemOrderId,
      this.strItemImageUrl,
      this.strItemName,
      this.strItemOrderNumber,
      this.strItemDateAndTime,
      this.strItemOrderStatus,
      this.strItemPrice});

  UserOrderModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      strItemCustomerId = map['id'];
    }

    if (checkForNull("first_name", map)) {
      strItemOrderId = map['first_name'];
    }

    if (checkForNull("last_name", map)) {
      strItemImageUrl = map['last_name'];
    }

    if (checkForNull("email", map)) {
      strItemName = map['email'];

      strItemOrderNumber = map['email'];
      strItemDateAndTime = map['email'];
      strItemOrderStatus = map['email'];
      strItemPrice = map['email'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
