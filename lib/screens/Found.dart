import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found/data/addchild.dart';
import 'package:found/data/addchild.dart';
import 'package:found/data/addchild.dart';
import 'package:found/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:found/screens/ChildInfo1.dart';

class FoundScreen extends StatefulWidget {

  @override
  _FoundScreenState createState() => _FoundScreenState();
}

class _FoundScreenState extends State<FoundScreen> {
  @override
  Widget build(BuildContext context) {
    print("in first state");
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[_Found()],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(bottom: 30, right: 30),
            child: FloatingActionButton(
              onPressed: () {
                //_FoundState._len=0;
                Navigator.of(context).pushNamed("/addchild");
              },
              tooltip: "Add Children",
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class _Found extends StatefulWidget {
  @override
  _FoundState createState() => _FoundState();
}

// ...............................
// .     all coming data here    .
// ...............................

class _FoundState extends State<_Found> {
  var url=Uri.http(MyApp.ip,"/ChildFound");
  List _Name = [];
  List _description = [];
  List _age = [];
  List<String> _image= [];
  List _location=[];
  List _phone =[];
  int _len = 0;
  static int inFile=0;
  bool isConnected=false;
  Future<http.Response> connect(dynamic url) async {
    print("connect");
    http.Response response;
    print(url);
    var client = http.Client();
     return client.get(url).then((value){
       print("get ");
       response =value;

       //print(response.body);
       int numOfChar = response.body.length;
       // Get Length
       // for getting length one time
       if (_len == 0) {
         for (int i = 0; i < numOfChar; i++) {
           if (response.body[i] == '}') {
             _len++;
             //print("the _len in found is $_len");
           }
         }

         //Set Fields
         for (int i = 0; i < _len; i++) {
           print("inloop $i");
           _Name.add(json.decode(response.body)[i]['name'].toString());
           _description.add(json.decode(response.body)[i]['description'].toString());
           _age.add(json.decode(response.body)[i]['age'].toString());
           String tnp=json.decode(response.body)[i]['image'].toString();
           _image.add(Uri.http(MyApp.ip, tnp).toString());
           _location.add(json.decode(response.body)[i]['location'].toString());
           _phone.add(json.decode(response.body)[i]['phone'].toString());
         }
       }
       client.close();
       return response;
    });


  }

  @override
  void initState() {

    super.initState();
    print("in initile state");
    isConnected=false;
     _Name = [];
     _description = [];
     _age = [];
     _image= [];
     _location=[];
     _phone =[];
     _len = 0;
  }


  @override
  void dispose() {
    print("in dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!isConnected){
      connect(url).then((value) {
        //TODO  check server error from response body
        print(value.body);
        // if no error => setState isConnected=true
        setState(() {isConnected=true;});
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
      //      if(AddChildState.childToServer.name!=null){
//        inFile++;
//        _Name.add(AddChildState.childToServer.name);
//        _phone.add(AddChildState.childToServer.phone);
//        _location.add(AddChildState.childToServer.locat);
//        _image.add(AddChildState.childToServer.image.path);
//        print(_image[0]);
//        print(_image[0].indexOf("storage/emulated/0/DCIM/"));
//        print(_image[0].substring(_image[0].indexOf("storage/emulated/0/DCIM/")));
//        _image[0]=_image[0].substring(_image[0].indexOf("storage/emulated/0/DCIM/"));
//        _age.add(AddChildState.childToServer.age);
//        _description.add(AddChildState.childToServer.Des);
//      }
    }
    else {
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
              itemCount: _len,
              itemBuilder: (BuildContext context, int index) {
                if(inFile>index) print("image[index] ${_image[index]}");
                return FoundDesign(_Name[index], _description[index],_location[index],_phone[index],_image[index]);
              },
            ),
          ),
        ),
      );
    }
  }
}

// .............................
//  here design for coming data.
// .............................

class FoundDesign extends StatefulWidget {
  String _name;
  String _description;
  String _location;
  String _phone;
  String img;
  bool isFile;
  FoundDesign(this._name, this._description,this._location,this._phone,this.img);
  @override
  _FoundDesignState createState() =>
      _FoundDesignState(_name,_description,_location,_phone,img);
}

class _FoundDesignState extends State<FoundDesign> {
  String _name;
  String _description;
  String _location;
  String _phone;
  String img;
//  bool isFile;
//  var imgFile;
  _FoundDesignState(this._name, this._description,this._location,this._phone,this.img);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChildInfo1(_name, _description,_location,_phone,img),
            ),
        );
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
              // TODO change it to image.network or img widget
              backgroundImage:NetworkImage(img)
//              !isFile?NetworkImage(img):FileImage(File(img)),
//              backgroundImage:NetworkImage(img),
//              child: Image.network(img),
              //AssetImage("images\\messi 3.jpg"),
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

