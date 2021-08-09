import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:found/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:found/screens/ChildInfo1.dart';

class NotFound extends StatefulWidget {
  @override
  NotFoundState createState() => NotFoundState();
}

class NotFoundState extends State<NotFound> {



  var url=Uri.http(MyApp.ip,"/ChildNotFound");

  List<String> _Name = [];
  List<String> _description = [];
  List<String> _age = [];
  List<String> _image= [];
  int len = 0;
  bool tryconnect=true;

  Future<List> connect(dynamic url) async {
    http.Response response;
    response = await http.get(url);
//    print(response.body);
    int numOfChar = response.body.length;

    // GetLength
    // to get length one time
    if (len == 0) {
      for (int i = 0; i < numOfChar; i++) {
        if (response.body[i] == '}') {
          len++;
    //      print("the len is $_len");
        }
      }
      //Set Fields
      for (int i = 0; i < len; i++) {
        _Name.add(json.decode(response.body)[i]['name'].toString());
        print("error");
        _description.add(json.decode(response.body)[i]['description'].toString());
        print("des error");
        _age.add(json.decode(response.body)[i]['age'].toString());
        print("age ${_age[i].runtimeType}");
        _image.add(Uri.http(MyApp.ip,json.decode(response.body)[i]['image'].toString()).toString());
        print("image");
      }
    }
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    if (tryconnect) {
      connect(url).then((value) {
        setState(() {
          tryconnect=false;
        });
      });
      return Expanded(
        child: Container(
          child:CircularProgressIndicator(backgroundColor: Colors.red,),
//          child: IconButton(
//            icon: Icon(
//              Icons.refresh,
//              size: 30,
//            ),
//            onPressed: () {
//              setState(() {});
//            },
//          ),
          alignment: Alignment.center,
        ),
      );
    }
    else {
      print("here error");
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: ListView.builder(
              itemCount: len,
              itemBuilder: (BuildContext context, int index) {
                print("move on ");
                print("Name ${_Name[index].runtimeType}");
                print("description ${_description[index].runtimeType}");
                print("image ${_image[index].runtimeType}");
                return _NotFoundScreen(_Name[index],_description[index], _image[index]);
              },
            ),
          ),
        ),
      );
    }
  }
}


class _NotFoundScreen extends StatefulWidget {
  String _name;
  String _description;
  String _image;
  _NotFoundScreen(this._name,this._description,this._image){
   print("in _notFoundScreen");
  }
  @override
  _NotFoundScreenState createState() => _NotFoundScreenState(this._name,this._description,this._image);
}

class _NotFoundScreenState extends State<_NotFoundScreen> {
  String _name ;
  String _description;
  String img;
  var imgFile;
  _NotFoundScreenState(this._name,this._description,this.img);
  @override
  Widget build(BuildContext context) {
    print("see it");
    return GestureDetector(
      onTap: () {
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => ChildInfo1(_name,_description,_location,_phone,img)));
      },
      child: Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Color(0xFFFFEFEE),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 35.0,
              backgroundImage: NetworkImage(img),
            ),
            SizedBox(width: 15.0),
            Text(
              _name,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
