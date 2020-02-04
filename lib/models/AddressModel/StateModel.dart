class StateModel {
  bool isDisabled = false;
  bool isSelected = false;
  var strText;
  var strValue;

  StateModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("Disabled", map)) {
      isDisabled = map["Disabled"];
    }
    if (checkForNull("Selected", map)) {
      isSelected = map["Selected"];
    }
    if (checkForNull("Text", map)) {
      strText = map["Text"];
    }
    if (checkForNull("Value", map)) {
      strValue = map["Value"];
    }
  }

  StateModel.fromMapForStates(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      strValue = map['id'];
    }
    if (checkForNull("name", map)) {
      strText = map['name'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
