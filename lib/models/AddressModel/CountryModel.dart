class CountryModel {
  bool isDisabled = false;
  bool isSelected = false;
  var strText;
  var strValue;

  CountryModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("Disabled", map)) {
      isDisabled = map['Disabled'];
    }
    if (checkForNull("Selected", map)) {
      isSelected = map['Selected'];
    }
    if (checkForNull("Text", map)) {
      strText = map['Text'];
    }
    if (checkForNull("Value", map)) {
      strValue = map['Value'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
