class ShoppingCartAttributeModel {
  //todo shopping
  bool isShowDiscountBox;
  bool isShowGiftCardBox;

  //todo shipping
  bool isEstimateShippingEnabled;
  bool isHideShippingTotal;
  bool isShipToSameAddress;
  bool isBypassShippingMethodSelectionIfOnlyOne;

  ShoppingCartAttributeModel.fromMapShopping(Map<String, dynamic> map) {
    if (checkForNull("ShowDiscountBox", map)) {
      isShowDiscountBox = map['ShowDiscountBox'];
    }
    if (checkForNull("ShowGiftCardBox", map)) {
      isShowGiftCardBox = map['ShowGiftCardBox'];
    }
  }

  ShoppingCartAttributeModel.fromMapShipping(Map<String, dynamic> map) {
    isEstimateShippingEnabled = map['EstimateShippingEnabled'];
    isHideShippingTotal = map['HideShippingTotal'];
    isShipToSameAddress = map['ShipToSameAddress'];
    isBypassShippingMethodSelectionIfOnlyOne =
        map['BypassShippingMethodSelectionIfOnlyOne'];
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
