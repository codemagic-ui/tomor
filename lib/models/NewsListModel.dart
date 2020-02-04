class NewsListModel {
  var strWorkingLanguageId;
  var strNewsTitle = "";
  var strNewsShortDescription;
  var strNewsDate;
  var strNewsFullDescription;
  var strCustomerPhone = "";
  var strCustomerUserName = "";

  var strUserRegistrationType;

  var strUserRegistrationTypeName = "";
  List<CommentListModel> commentModelList;

  NewsListModel(
      {this.strWorkingLanguageId,
      this.strNewsTitle,
      this.strNewsShortDescription,
      this.strNewsDate,
      this.strNewsFullDescription,
      this.strCustomerPhone});

  NewsListModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("Title", map)) {
      strNewsTitle = map["Title"];
    }
    if (checkForNull("Short", map)) {
      strNewsShortDescription = map["Short"];
    }
    if (checkForNull("CreatedOn", map)) {
      strNewsDate = map["CreatedOn"];
    }
    if (checkForNull("Full", map)) {
      strNewsFullDescription = map["Full"];
    }
    if (checkForNull("Comments", map)) {
      List commentList = map["Comments"];
      commentModelList =
          commentList.map((c) => new CommentListModel.fromMap(c)).toList();
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}

class CommentListModel {
  var strCommentId;
  var strCommenterName;
  var strCommentDate;
  var strCommentTitle;
  var strCommentDescription;

  CommentListModel.fromMap(Map<String, dynamic> map) {
    if (checkForNull("CustomerId", map)) {
      strCommentId = map["CustomerId"];
    }
    if (checkForNull("CustomerName", map)) {
      strCommenterName = map["CustomerName"];
    }
    if (checkForNull("CreatedOn", map)) {
      strCommentDate = map["CreatedOn"];
    }
    if (checkForNull("CommentTitle", map)) {
      strCommentTitle = map["CommentTitle"];
    }
    if (checkForNull("CommentText", map)) {
      strCommentDescription = map["CommentText"];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
