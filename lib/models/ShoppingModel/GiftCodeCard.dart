
class GiftCodeCard {
  var mCouponCode;
  var mAmount;
  var mRemaining;
  var mId;

  GiftCodeCard.fromMapGiftCodeCard(Map<String, dynamic> map) {
    if (checkForNull("CouponCode", map)) {
      mCouponCode = map['CouponCode'];
    }

    if (checkForNull("Amount", map)) {
      mAmount = map['Amount'];
    }

    if (checkForNull("Remaining", map)) {
      mRemaining = map['Remaining'];
    }

    if (checkForNull("Id", map)) {
      mId = map['Id'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
