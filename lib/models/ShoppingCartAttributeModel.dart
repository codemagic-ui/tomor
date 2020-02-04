
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
    isShowDiscountBox = map['ShowDiscountBox'];
    isShowGiftCardBox = map['ShowGiftCardBox'];
  }

  ShoppingCartAttributeModel.fromMapShipping(Map<String, dynamic> map) {
    isEstimateShippingEnabled = map['EstimateShippingEnabled'];
    isHideShippingTotal = map['HideShippingTotal'];
    isShipToSameAddress = map['ShipToSameAddress'];
    isBypassShippingMethodSelectionIfOnlyOne =
        map['BypassShippingMethodSelectionIfOnlyOne'];
  }
}
