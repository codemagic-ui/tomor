import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_a_student/models/ProductListModel.dart';
import 'package:i_am_a_student/pages/ErrorScreenPage.dart';
import 'package:i_am_a_student/pages/NoIntenetScreen.dart';
import 'package:i_am_a_student/pages/ProductListScreen.dart';
import 'package:i_am_a_student/parser/AddProductIntoCartParser.dart';
import 'package:i_am_a_student/parser/BrandListParser.dart';
import 'package:i_am_a_student/parser/GetImageSliderParser.dart';
import 'package:i_am_a_student/utils/AnimationBetweenPage.dart';
import 'package:i_am_a_student/utils/AppColor.dart';
import 'package:i_am_a_student/utils/Config.dart';
import 'package:i_am_a_student/utils/Constants.dart';
import 'package:i_am_a_student/utils/ImageSlider.dart';
import 'package:i_am_a_student/utils/ImageStrings.dart';
import 'package:i_am_a_student/utils/SpinKitThreeBounce.dart';
import 'package:i_am_a_student/utils/TextStyle.dart';
import 'package:i_am_a_student/models/ImageSliderModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandListScreen extends StatefulWidget {
  @override
  _BrandListScreenState createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  bool isInternet;
  bool isError = false;
  bool isLoading;

  List<ProductListModel> brandProductList = new List<ProductListModel>();

  double itemWidth;
  double itemHeight;

  SharedPreferences prefs;

  int customerId;

  ImageSliderModel mSliderImages;

  @override
  void initState() {
    internetConnection();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    itemHeight = 190.0;
    itemWidth = 130.0;
    if (isInternet != null && isInternet) {
      if (!isError) {
        if (isLoading != null && isLoading) {
          callApi();
        } else if (isLoading != null && !isLoading) {
          return layoutMain();
        }
      } else {
        return ErrorScreenPage();
      }
    } else if (isInternet != null && !isInternet) {
      return NoInternetScreen(
        onPressedRetyButton: () {
          internetConnection();
        },
      );
    }
    return Scaffold(
      body: Center(
        child: SpinKitThreeBounce(
          color: AppColor.appColor,
          size: 30.0,
        ),
      ),
    );
  }

  Widget layoutMain() {
    return Directionality(
      textDirection: Constants.checkRTL != null && Constants.checkRTL
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: brandPageLayout(),
      ),
    );
  }

  Widget brandPageLayout() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(),
            child: Container(
              child: ListView(
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                //  imageSlider(),
                  gridList(),
                  //region CategoryList
                  //endregion
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          );
        });
  }


  Widget imageSlider() {
    if (mSliderImages != null) {
      if (mSliderImages.mPicture1UrlList != null &&
          mSliderImages.mPicture1UrlList.length != 0) {
        List<CachedNetworkImageProvider> imageList =
        new List<CachedNetworkImageProvider>();
        for (int i = 0; i < mSliderImages.mPicture1UrlList.length; i++) {
          imageList.add(CachedNetworkImageProvider(
              mSliderImages.mPicture1UrlList[i].toString()));
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height:
            180.0 * MediaQuery.of(context).size.width / 423.5294196844927,
            child: ImageSlider(
              onClickItem: () {},
              boxFit: BoxFit.cover,
              autoplay: true,
              image: imageList,
              indicatorBgPadding: 10.0,
              dotSize: 5.0,
              dotSpacing: 20.0,
              dotBgColor: Colors.transparent,
              dotColor: Colors.black,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(seconds: 2),
              autoplayDuration: Duration(seconds: 4),
              overlayShadow: true,
              overlayShadowColors: Colors.white.withOpacity(0.0),
              overlayShadowSize: 1.0,
              borderRadius: true,
              moveIndicatorFromBottom: 10.0,
              radius: Radius.circular(5.0),
            ),
          ),
        );
      } else {
        return Container();
      }
    }
    return Container();
  }

  Widget gridList() {
    return new GridView.count(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      childAspectRatio: (1 / 1.4),
      padding: EdgeInsets.all(8.0),
      children: List.generate(brandProductList.length, (index) {
        final item = brandProductList[index];
        return InkWell(
          onTap: () {

            navigatePush(ProductListScreen(
              categoryName: brandProductList[index].name,
              manufactureId: brandProductList[index].id,
              isFromBrandList: true,
            ));
          },
          child: new Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0),
                    child: CachedNetworkImage(
                      imageUrl: item.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        ImageStrings.imgPlaceHolder,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 8.0),
                      child: HeadlineText(
                        text: item.name,
                        color: AppColor.appColor,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  callApi() async {
    isInternet = await Constants.isInternetAvailable();

    if (isInternet != null && isInternet) {
      await getSharedPreferences();
      await getShoppingCartItemNumber();
      await getSliderImage();
      await brandList();
      isLoading = false;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  Future getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt(Constants.prefUserIdKeyInt);
  }

  Future getShoppingCartItemNumber() async {
    Map result = await AddProductIntoCartParser.callApiForGetCartItemTotal(
        "${Config.strBaseURL}shopping_cart_items/" + customerId.toString());
    if (result["errorCode"] == "0") {
      Constants.cartItemCount = result["value"];
    } else {
      isError = true;
    }
    isLoading = false;
  }

  Future brandList() async {
    Map result = await BrandListParser.callApi(
        "${Config.strBaseURL}categories/getallmanufacturer");
    if (result["errorCode"] == "0") {
      brandProductList = result["value"];
    } else {
      isError = true;
    }
    isLoading = false;
  }

  internetConnection() async {
    isInternet = await Constants.isInternetAvailable();
    isLoading = isInternet;
    if (this.mounted) {
      setState(() {});
    }
  }

  navigatePush(Widget page) async {
    await Navigator.push(
        context, AnimationPageRoute(page: page, context: context));
  }

  navigatePushReplacement(Widget page) async {
    await Navigator.pushReplacement(
        context, AnimationPageRoute(page: page, context: context));
  }

  Future getSliderImage() async {
    Map result = await GetImageSliderParser.callApi(
        "${Config.strBaseURL}orders/nivosliderimage");
    if (result["errorCode"] == "0") {
      mSliderImages = result["value"];
    } else {
    }
  }
}
