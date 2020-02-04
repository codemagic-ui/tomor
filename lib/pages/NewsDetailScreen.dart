import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/models/NewsListModel.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Buttons.dart';
import 'package:i_am_a_student/utils/Constants.dart';

import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsListModel mNewsListModel;

  NewsDetailScreen({this.mNewsListModel});

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool isInternet;

  @override
  void initState() {
    internetConnection();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    if (isInternet != null && isInternet) {
      return layoutMain();
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () async {
          internetConnection();
        },
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: SpinKitThreeBounce(color: AppColor.appColor,size: 30.0,),
        ),
      );
    }
  }



  Widget layoutMain() {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("News"),
      ),
      body: new SafeArea(
        child: ListView(
          padding: EdgeInsets.all(8.0),
          shrinkWrap: true,
          children: <Widget>[
            TitleText(maxLine: 1, text: widget.mNewsListModel.strNewsTitle),
            SizedBox(
              height: 3.0,
            ),
            SubHeadText(
              maxLine: 1,
              text:
                  "${formatDate(DateTime.parse(widget.mNewsListModel.strNewsDate), [
                dd,
                '-',
                mm,
                '-',
                yyyy
              ])}",
              color: Colors.blueAccent,
            ),
            SizedBox(
              height: 8.0,
            ),
            Html(
              data: widget.mNewsListModel.strNewsFullDescription,
              padding: EdgeInsets.all(8.0),
              onLinkTap: (url) async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            TitleText(text: "Leave your comment"),
            SizedBox(
              height: 8.0,
            ),
            Body2Text(text: "Title :"),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 8.0),
              height: 50.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextFormField(
                  decoration: InputDecoration.collapsed(hintText: "Title "),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Body2Text(text: "Comment :"),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 8.0),
              height: 100.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration.collapsed(hintText: "Comment "),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            RaisedBtn(
              onPressed: () {},
              text: "New Comment".toUpperCase(),
              elevation: 0.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            widget.mNewsListModel.commentModelList.length != null &&
                    widget.mNewsListModel.commentModelList.length != 0
                ? commentLayout()
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget commentLayout() {
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: <Widget>[
        new TitleText(text: "Comments"),
        SizedBox(
          height: 8.0,
        ),
        new ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: widget.mNewsListModel.commentModelList.length,
            padding: EdgeInsets.only(
                top: 8.0,
                bottom: 8.0),
            itemBuilder: (BuildContext context, int position) {
              return Container(
                height: 120.0,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            TitleText(
                              maxLine: 1,
                              text: widget.mNewsListModel
                                  .commentModelList[position].strCommenterName,
                            ),
                            SizedBox(
                              width: 3.0,
                            ),
                            Body1Text(
                              maxLine: 1,
                              text:
                                  "${formatDate(DateTime.parse(widget.mNewsListModel.commentModelList[position].strCommentDate), [
                                dd,
                                '-',
                                mm,
                                '-',
                                yyyy
                              ])}",
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Body2Text(
                            maxLine: 1,
                            text: widget.mNewsListModel
                                .commentModelList[position].strCommentTitle),
                        SizedBox(
                          height: 8.0,
                        ),
                        Flexible(
                          child: SmallText(
                              maxLine: 3,
                              text: widget
                                  .mNewsListModel
                                  .commentModelList[position]
                                  .strCommentDescription),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }


  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();

    setState(() {});
  }
}
