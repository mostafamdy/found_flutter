import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:found/main.dart';
import 'package:found/screens/ChildInfo1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
class Sreach extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Sreachs();
  }
}
class Sreachs extends State<Sreach> {
  static var _status = ["search for child", "found child"];
  String _testdropdown = _status[0];
  String _name='',_description='',_age='';
  Future<File> file;

  imageCamera() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
  }
  imageGallery() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            Container(
              child: Text(
                "Sreach for Children",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.red,
                ),
              ),
            ),
            // dropdown
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: DropdownButton(
                value: _testdropdown,
                items: _status.map((String dropDownItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownItem,
                    child: Text(dropDownItem),
                  );
                }).toList(),
                style: textStyle,
                onChanged: (selectedItem) {
                  setState(() {
                    _testdropdown = selectedItem;
                  });
                },
              ),
            ),
            //........name.........
            Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: TextField(
                style: textStyle,
                onChanged: (value) {
                  _name=value;
                },
                decoration: InputDecoration(
                    labelText: "Name :",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
              ),
            ),
            //.........age..........
            Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: TextField(
                style: textStyle,
                onChanged: (value) {
                  _age=value;
                },
                decoration: InputDecoration(
                    labelText: "Age :",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
              ),
            ),
            //.........description......
            Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: TextField(
                style: textStyle,
                onChanged: (value) {
                  _description=value;
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
            //........image......
            Row(
              children: <Widget>[
                Container(
                  width: 10.0,
                ),
                //......image from camera........
                IconButton(
                  icon: Icon(Icons.add_a_photo),
                  iconSize: 30.0,
                  color: Colors.black45,
                  onPressed: () {
                    imageCamera();
                  },
                ),
                Container(
                  width: 10.0,
                ),
                //..........image from gallery..........
                IconButton(
                  icon: Icon(Icons.insert_photo),
                  iconSize: 30.0,
                  color: Colors.black45,
                  onPressed: () {
                    imageGallery();
                  },
                )
              ],
            ),
            // ..........search button..........
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Sreach',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        file.then((value) async {
                          var imgByts=await value.readAsBytes();
                          String base64encode=await base64Encode(imgByts);
                          var url=Uri.http(MyApp.ip,"/sendNotFoundChild");
                          http.post(url,headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                              body:jsonEncode(
                                  {
                                    "name":_name,
                                    "description":_description,
                                    "age":_age,
                                    "imagebase64":base64encode
                                  })
                          ).then((value){
                           print(value.body);
                           if(value.body=="not found "){

                             Navigator.push(context, MaterialPageRoute(builder: (context)=>Scaffold(body: Center(child: Text("not found"),),)));
                           }
                           else{
                             String foundname=jsonDecode(value.body)[0]['name'].toString();
                             String foundage=jsonDecode(value.body)[0]['age'].toString();
                             String founddesc=jsonDecode(value.body)[0]['description'].toString();
                             String foundlocation=jsonDecode(value.body)[0]['location'].toString();
                             String foundimage=jsonDecode(value.body)[0]['image'].toString();
                             String foundphone=jsonDecode(value.body)[0]['phone'].toString();
                             foundimage=Uri.http(MyApp.ip, foundimage).toString();
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>ChildInfo1(foundname,founddesc,foundlocation,foundphone,foundimage),),);
                           }
                          });
                        });
                       // Navigator.of(context).pushNamed("/HomeScreen");
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
