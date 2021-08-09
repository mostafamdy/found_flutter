import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found/data/Parentdata.dart';

class ChildInfo1 extends StatefulWidget {
  String _name;
  String _description;
  String _location;
  String _phone;
  String img;
  static String image;

  ChildInfo1(
      this._name, this._description, this._location, this._phone, this.img);

  @override
  _ChildInfo1State createState() => _ChildInfo1State();
}

class _ChildInfo1State extends State<ChildInfo1> {
//  var imgFile;

  @override
  Widget build(BuildContext context) {
    ChildInfo1.image=widget.img;
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
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
//              Image.file(imgFile),
        // TODO CHANGE IT TO IMG WIDGET OR IMAGE.NETWORK (URL = URL OF SERVER)
//          Image.asset("images\\messi 3.jpg"),
          Image.network(widget.img,height: MediaQuery.of(context).size.height/2,width: MediaQuery.of(context).size.width,),
          Container(
            padding: EdgeInsets.only(left: 20, top: 40),
            alignment: Alignment.topLeft,
            child: Text(
              widget._name,
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
          ),
          Text(
            widget._description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
          ),

          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 150),
            //.......................................................................................
            // getting child location and send Necessary parent data for making sure he is rely parent
            // ......................................................................................
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ParentsData(widget._location, widget._phone)),
                );
              },
              child: Text(
                "get his Location",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
