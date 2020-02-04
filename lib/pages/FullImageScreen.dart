import 'package:flutter/material.dart';
import 'package:i_am_a_student/models/productDetail/ImageListModel.dart';
import 'package:photo_view/photo_view.dart';

class FullImageScreen extends StatefulWidget {
  final  List<ImageListModel> imageList ;
  final String title;
  final int index;
  static int initPage = 0;

  FullImageScreen(this.imageList, this.title, this.index){initPage = index;}

  @override
  _FullImageScreenState createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {

  PageController _controller = new PageController(initialPage: FullImageScreen.initPage);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        leading: new InkWell(
          onTap: (){Navigator.pop(context);},
          child: new Icon(Icons.arrow_back,color: Colors.white),),
        title: new Text(widget.title,style: Theme.of(context).textTheme.title.apply(color: Colors.white),),backgroundColor: Colors.black,),
      body:_pageView(),
    );
  }

  Widget _pageView(){
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new PageView.builder(
          controller: _controller,
          itemCount: widget.imageList.length,
          itemBuilder: (BuildContext context,int index){
            return new PhotoView(imageProvider: new  NetworkImage(widget.imageList[index].url));
          },
        )
      ],
    );

  }
}
