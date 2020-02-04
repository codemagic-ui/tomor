import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/RatingBar.dart';

import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ProductAllItem extends StatefulWidget {
  final GestureTapCallback onTapProductItem;
  final GestureTapCallback onTapFav;
  ProductListModel model;

  ProductAllItem(
      {@required this.onTapProductItem,
        @required this.onTapFav,
        @required this.model});

  @override
  _ProductAllItemState createState() => _ProductAllItemState(model);
}

class _ProductAllItemState extends State<ProductAllItem> {
  _ProductAllItemState(this.model);

  ProductListModel model;
  Map resourceData;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoginId();
  }

  getUserLoginId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonData = sharedPreferences.getString(Constants.prefMap);
    resourceData = json.decode(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: new Container(
        width: 400.0,
        margin: EdgeInsets.only(
          right: 0.0,
        ),
        child: SizedBox(
          child: InkWell(
            onTap: widget.onTapProductItem,
            child: new Card(
              child: Column(
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      new Container(
                        height: MediaQuery.of(context).size.height/3.7,
                        width: MediaQuery.of(context).size.width/1,
                        padding: EdgeInsets.all(2.0),
                        child: new ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4.0),
                              topLeft: Radius.circular(4.0)),
                          child: CachedNetworkImage(
                            imageUrl: model.image.toString(),
                            placeholder: (context, url) => Image.asset(
                              ImageStrings.imgPlaceHolder,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.0),
                  new Container(
                    margin: EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: new Stack(
                      alignment: Alignment(
                          Constants.checkRTL != null && Constants.checkRTL
                              ? 1.9
                              : 0.9,
                          -1.3),
                      children: <Widget>[
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Body1Text(
                              text: model.name,
                              maxLine: 2,
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            new Padding(
                              padding: EdgeInsets.only(bottom: 3.0),
                              child: new RatingBar(
                                size: 15.0,
                                rating: double.parse(model.rating.toString()),
                                color: AppColor.appColor,
                              ),
                            ),
                            oldPriceText(),
                            SizedBox(height: 8.0),
                            price(),
                          ],
                        ),
                        new Padding(
                            padding: EdgeInsets.only(top: 40.0),
                            child: new GestureDetector(
                              onTap: widget.onTapFav,
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColor.appColor,
                                  ),
                                ),
                                child: model.IsProductInWishList?Icon(
                                  Icons.favorite,
                                  color: AppColor.appColor,
                                  size: 15.0,
                                ):Icon(
                                  Icons.favorite_border,
                                  color: AppColor.appColor,
                                  size: 15.0,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  oldPriceText() {
    if (model.oldPrice != null) {
      return new RichText(
        maxLines: 1,
        text: new TextSpan(
          text: "${model.oldPrice}",
          style: new TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              fontSize: 12.0),
        ),
      );
    }
  }

  price() {
    String price;
    if (model.price != null && model.price.toString().isNotEmpty) {
      price = model.price.toString();
    }
    if (model.tierPriceModelList.length > 0) {
      price = "From ${model.tierPriceModelList.last.price.toString()}";
    }
    if (price != null) {
      return Body2Text(
        color: AppColor.appColor,
        text: price,
        maxLine: 1,
      );
    }
    return Container();
  }
}

class ProductItemBestSeller extends StatefulWidget {
  final GestureTapCallback onTapProductItem;
  final GestureTapCallback onTapFav;
  ProductListModel model;
  final Map resourceData;

  ProductItemBestSeller(
      {@required this.onTapProductItem,
        @required this.onTapFav,
        @required this.model,
        @required this.resourceData});

  @override
  _ProductItemBestSeller createState() => _ProductItemBestSeller(model);
}

class _ProductItemBestSeller extends State<ProductItemBestSeller> {
  _ProductItemBestSeller(this.model);

  ProductListModel model;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: InkWell(
        onTap: widget.onTapProductItem,
        child: new Card(
          elevation: 3.0,
          child: new Container(
            padding: const EdgeInsets.all(2.0),
            width: 200.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Center(
                      child: new ClipRRect(
                        borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            bottomLeft: Radius.circular(4.0)),
                        child: CachedNetworkImage(
                          imageUrl: model.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            ImageStrings.imgPlaceHolder,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 8.0, top: 3.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Body1Text(
                          text: model.name,
                          maxLine: 2,
                        ),
                        SizedBox(height: 3.0),
                        model.rating > 0
                            ? new Padding(
                          padding: EdgeInsets.only(bottom: 3.0),
                          child: new RatingBar(
                            size: 15.0,
                            rating: double.parse(model.rating.toString()),
                            color: AppColor.appColor,
                          ),
                        )
                            : Container(),
                        SizedBox(height: 3.0),
                        oldPriceText(),
                        SizedBox(height: 8.0),
                        price(),
                        SizedBox(height: 2.0),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(6.0),
                    child: new GestureDetector(
                      onTap: widget.onTapProductItem,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColor.appColor,
                              ),
                            ),
                            child: Icon(
                              Icons.favorite_border,
                              color: AppColor.appColor,
                              size: 15.0,
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget oldPriceText() {
    if (model.oldPrice != null) {
      return new RichText(
        maxLines: 1,
        text: new TextSpan(
          text: "${model.oldPrice}",
          style: new TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              fontSize: 12.0),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget price() {
    String price;
    if (model.price != null && model.price.toString().isNotEmpty) {
      price = model.price.toString();
    }
    if (model.tierPriceModelList.length > 0) {
      price = Constants.getValueFromKey(
          "Admin.System.QueuedEmails.Fields.From", widget.resourceData) +
          " ${model.tierPriceModelList.last.price.toString()}";
    }
    if (price != null) {
      return Body2Text(
        color: AppColor.appColor,
        text: price,
        maxLine: 1,
      );
    }
    return Container();
  }
}
