import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:found/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddChild extends StatefulWidget {
  @override
  AddChildState createState() => AddChildState();
}

class AddChildState extends State<AddChild> {
  String  _location;
  int _age;
  File file;
//  File tmfile;
  String base64encode = "";
//  List bad=[];
//  List good=[];
//  int len;
//  int l=0;
//  bool imageUploaded=false;
  String _ip=MyApp.ip;
  static ChildFound childToServer=ChildFound();
  @override
  void initState() {
    
  }


//  Future<bool> sendImage() async {
//    var url=Uri.http(_ip,"/sendimage");
//    return file.readAsBytes().then((value) async {
//      base64encode=base64Encode(value);
//
//      return http.post
//        (
//          url,
//          headers: <String, String>{
//            'Content-Type': 'application/json; charset=UTF-8',
//          },
//          body:jsonEncode(
//              {
//                'imageBase64':base64encode,'childID':
//              })
//      ).then((value) {
//        print(value.body);
//        print("image uploaded complete");
//        imageUploaded=true;
//        return true;
//      });
//
//    });
//    // bad and good are empty lists
////    if(response.body!="GOOD WORK"&&f==0){
////      print("I am in bad request and the index is $index");
////      setState(() {
////        bad = bad;
////        bad.add({'index':index,'name':im});
////      }
////      );
////      print("Bad Length is ${bad.length}");
////    }
////
////    else{
////      if(f==0){
////        print("I am in GOOD request and the index is $index");
////        setState(() {
////          good = good;
////          good.add({'index':index,'name':im});
////        }
////        );
////        print("Good Length is ${good.length}");
////      }
////    }
////
////    if(response.body == "GOOD WORK"&&f>0){
////      setState(() {
////        bad = bad;
////        bad.removeAt(f);
////        print(bad.length);
////        good=good;
////        good.add({'index':index,'name':im});
////      });
////      print("Bad Length is ${bad.length}");
////    }
////
////    if((bad.length+good.length)==len&&f==0){
////      print("iam in resend statement");
//////      while(bad.length!=0){
//////        setState(() {
//////          test(bad[l]['name'],bad[l]['index'],l+1,ChildID);
//////          l=l+1;
//////          print(l);
//////          if(l>=bad.length){
//////            l=0;
//////          }
//////        });
////      }
//
//  }
  imageGallery() {
    setState(() async {
      print ("image picker");
      file = await ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  imageFromCamera() {
    setState(() async {
      file =await ImagePicker.pickImage(source: ImageSource.camera);
    });
  }


//  Widget showImage() {
//    //print("Iam in showImage and ChildID is $_ChildID");
//    return FutureBuilder(
//      future: file,
//      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//          tmfile=snapshot.data;
//          var byte = snapshot.data.readAsBytesSync();
//          base64encode = base64Encode(byte);
////          print("this is base 64 encode Length");
////          print(base64encode.length);
////          print("type");
////          print(byte.runtimeType);
////          print("element type");
////          print(byte[0].runtimeType);
////          print("byte[0]");
////          print(byte[0]);
////          print("body");
////          print(byte);
//
//          return Container(
//            alignment: Alignment.topLeft,
//            padding: EdgeInsets.only(left: 50),
//            height: 200,
//            width: 150,
//            child: Image.file(snapshot.data),
//          );
//        }
//        else {
//          return Container();
//        }
//      },
//    );
//  }


  Widget showImage()=>Container(color: Colors.purple,);

  void _getLocation() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _location = "${position.latitude}, ${position.longitude}";
    });
  }


  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        title: Text(
          'found',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          // title
          Container(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "Child Info",
              style: TextStyle(
                fontSize: 40,
                color: Colors.red,
              ),
            ),
          ),
          //Name
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
            child: TextField(
              style: textStyle,
              onChanged: (value) {
                print(value);
                childToServer.name = value.toString();
              },
              decoration: InputDecoration(
                labelText: "Name :",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          //age
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
            child: TextField(
              style: textStyle,
              onChanged: (value) {
                childToServer.age = int.parse(value);
              },
              decoration: InputDecoration(
                labelText: "Age :",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          //description
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
            child: TextField(
              style: textStyle,
              onChanged: (value) {
                childToServer.Des = value.toString();
              },
              decoration: InputDecoration(
                labelText: "Description :",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),

          //location ___image___camera
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30, left: 30),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add_a_photo),
                      iconSize: 30.0,
                      color: Colors.black45,
                      onPressed: () {
                        imageFromCamera();
                      },
                    ),
                    Container(
                      width: 10.0,
                    ),
                    IconButton(
                      icon: Icon(Icons.insert_photo),
                      iconSize: 30.0,
                      color: Colors.black45,
                      onPressed: () {
                        imageGallery();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 30, top: 30),
                child: RaisedButton(
                  color: Color.fromRGBO(240, 20, 60, 1),
                  child: Text(
                    "Send your Location",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: () {
                    String Link = "";
                    print("this is location button");
                    _getLocation();
                    print(_location);
                    print("file is $file");
                  },
                  elevation: 7,
                  colorBrightness: Brightness.dark,
                  highlightElevation: 10,
                ),
              ),
            ],
          ),
          showImage(),
          //send
          Container(
            padding: EdgeInsets.only(right: 50, bottom: 50),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              hoverElevation: 100,
              onPressed: () {
                childToServer.locat="x,y";
                childToServer.image=file;
                Navigator.of(context).pushNamed("/SomeOneInfo");
//                setState(()
//                    {
//                      len=((_image.length)/100000).toInt();
//                      if(_image.length%100000!=0){
//                        len++;
//                      }
//                    });
//                print("LENGTH IS $len");
//                test(" ",len,-1,_ChildID);
//                int k=0;
//                for(int i=0;i<len;i++){
//                  if(len-1==i){
//                   test(_image.substring(k),i,0,_ChildID);
//                    print("Last one");
//                  }
//                  else{
//                    test(_image.substring(k, k+100000),i,0,_ChildID);
//                    k+=100000;
//                  }
//                }

                },
              child: Icon(
                Icons.arrow_forward_ios,
                size: 30,
                color: Colors.white,
              ),
              splashColor: Colors.white,
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class SomeOneInfo extends StatefulWidget {
  @override
  _SomeOneInfoState createState() => _SomeOneInfoState();
}

class _SomeOneInfoState extends State<SomeOneInfo> {

  String _name, _phoneNumber;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        title: Text(
          'found',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "your Info",
              style: TextStyle(
                fontSize: 40,
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
            child: TextField(
              style: textStyle,
              onChanged: (value) {
                print(value);
                _name = value.toString();
              },
              decoration: InputDecoration(
                labelText: "Name :",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
            child: TextField(
              style: textStyle,
              onChanged: (value) {
                print(value);
                _phoneNumber = value.toString();
              },
              decoration: InputDecoration(
                labelText: "phone Number :",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, right: 50, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                  hoverElevation: 100,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Colors.white,
                  ),
                  splashColor: Colors.white70,
                  backgroundColor: Colors.red,
                ),
                RaisedButton(
                  child: Text(
                    "Send",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  onPressed: () {
                    AddChildState.childToServer.phone=_phoneNumber;
                    AddChildState.childToServer.founderName=_name;
                    AddChildState.childToServer.sendChild();
//                    MaterialPageRoute(builder: (context) => Container());
                    Navigator.of(context).pushNamed("/HomeScreen");

                  },
                  color: Colors.redAccent,
                  colorBrightness: Brightness.dark,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChildFound{
  String name;
  String Des;
  String locat;
  int age;
  File image;
  String founderName;
  String phone;
  sendChild() async
  {
    String base64encode;
    locat="x,y";
    var url=Uri.http(MyApp.ip,"/sendFoundChild");
    var imgbytes=await image.readAsBytes();
    base64encode=await base64Encode(imgbytes);
    print("base64 $base64encode");
    http.Response response;

//    String url2="?name=$name&age=$age&location=$locat&description=$Des&image=Image";
//    response = await http.get(url.toString()+url2);
    response=await http.post(
        url.toString(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            {
              "name":name,
              "age":age,
              "location":locat,
              "description":Des,
              "imageBase64":base64encode,
              "founderName":founderName,
              "phone":phone
            }
        )
    );
  }

}
