class CouponCodeModel {
  var couponCode;
  var couponId;

  CouponCodeModel.fromMapCoupon(Map<String, dynamic> map) {
    if (checkForNull("CouponCode", map)) {
      couponCode = map['CouponCode'];
    }

    if (checkForNull("Id", map)) {
      couponId = map['Id'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
