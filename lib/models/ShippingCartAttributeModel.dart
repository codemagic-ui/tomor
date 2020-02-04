class ShippingCartAttributeModel {
  bool isEstimateShippingEnabled;
  bool isHideShippingTotal;
  bool isShipToSameAddress;
  bool isBypassShippingMethodSelectionIfOnlyOne;

  ShippingCartAttributeModel.fromMapShipping(Map<String, dynamic> map) {
    if (checkForNull("EstimateShippingEnabled", map)) {
      isEstimateShippingEnabled = map['EstimateShippingEnabled'];
    }

    if (checkForNull("HideShippingTotal", map)) {
      isHideShippingTotal = map['HideShippingTotal'];
    }

    if (checkForNull("ShipToSameAddress", map)) {
      isShipToSameAddress = map['ShipToSameAddress'];
    }

    if (checkForNull("BypassShippingMethodSelectionIfOnlyOne", map)) {
      isBypassShippingMethodSelectionIfOnlyOne =
          map['BypassShippingMethodSelectionIfOnlyOne'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
