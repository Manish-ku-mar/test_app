import 'package:flutter/material.dart';
import '../models/details.dart';
import '../widget/details.dart';
import '../models/getuserDescription.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import '/services/database.dart';

class AboutUserScreen extends StatefulWidget {
  static const String route = '/AboutUserScreen';

  @override
  State<AboutUserScreen> createState() => _AboutUserScreenState();
}

class _AboutUserScreenState extends State<AboutUserScreen> {
  Map<String, dynamic>? currentUserData;
  Map<String, dynamic>? data;
  bool dataPresent = false;
  String description = "Other";
  List<Details> detailList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    disableCapture();
  }

  Future<void> disableCapture() async {
    //disable screenshots and record screen in current screen
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    data = ModalRoute.of(context) == null
        ? null
        : ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (!dataPresent) {
      Database().getCurrentUserGroup().then((value) {
        currentUserData = value;
        if (data == null || currentUserData == null) {
          return;
        }
        // print();
        detailList = describeUserData(
            currentUserData!['user_group'] + " ${currentUserData!['Gender']}");
        // print(detailList);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigoAccent,
        appBar: AppBar(
          title: Text("INTRO App"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [],
        ),
        body: data == null
            ? Center(child: Text("Error"))
            : ProfileWidget(data!, description, detailList));
  }
}

class ProfileWidget extends StatefulWidget {
  Map<String, dynamic> data = {};
  String description;
  List<Details> detailList;

  ProfileWidget(this.data, this.description, this.detailList);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  int selectedindex = 0;
  PageController _pageController = PageController(initialPage: 0);

  String imagePath =
      "https://st2.depositphotos.com/1104517/11965/v/600/depositphotos_119659092-stock-illustration-male-avatar-profile-picture-vector.jpg";

  Widget build(BuildContext context) {
    List<Widget> detailWidgetList = [];
    widget.detailList.forEach((element) {
      detailWidgetList.add(DetailsCard(
          image: element.image,
          title: element.title,
          Description: element.desc));
      print(element);
    });

    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Center(child: ImageWidget()),
          SizedBox(
            height: size.height * 0.01,
          ),
          Center(
            child: Text(widget.data["Name"],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Center(
            child: Text(widget.data["phoneNo"],
                style: TextStyle(color: Colors.black, fontSize: 15)),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Center(
            child: Text(widget.data["Gender"],
                style: TextStyle(color: Colors.black, fontSize: 15)),
          ),

          SizedBox(
            height: size.height * 0.01,
          ),
          //  Container(
          //    decoration: BoxDecoration( color: Colors.white ,border: Border.all(color:Colors.black)),
          //    child: ListTile(
          //        leading: Icon(Icons.description),
          //         title:Text(widget.description)),
          //  ),

          // SizedBox(
          //   height: size.height * 0.1,
          // ),
          profile(context, widget.detailList),
        ],
      ),
    );
  }

  Widget ImageWidget() {
    final image = NetworkImage(imagePath);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          height: 120,
          width: 120,
          child: InkWell(
            onTap: () {
              print("yes");
            },
          ),
        ),
      ),
    );
  }

  Widget profile(BuildContext context, List<Details> widgetList) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .6,
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                selectedindex = index;
              });
            },
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widgetList.length,
            itemBuilder: (context, index) {
              return DetailsCard(
                title: widgetList[index].title,
                Description: widgetList[index].desc,
                image: widgetList[index].image,
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPageIndicator(widgetList),
        )
      ],
    );
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.black : Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator(List<Details> lists) {
    List<Widget> list = [];
    for (int i = 0; i < lists.length; i++) {
      list.add(i == selectedindex ? _indicator(true) : _indicator(false));
    }
    return list;
  }
}
