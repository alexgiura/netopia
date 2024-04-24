//The Menu Model
import 'package:flutter/material.dart';

class Menu {
  int id = 0;
  int level = 0;
  IconData? icon = Icons.drive_file_rename_outline;
  String title = "";
  String? subtitle = "";
  List<Menu> children = [];
  //default constructor
  Menu(this.id, this.level, this.icon, this.title, this.children);

  //one method for  Json data
  Menu.fromJson(Map<String, dynamic> json) {
    //id
    if (json["id"] != null) {
      id = json["id"];
    }
    //level
    if (json["level"] != null) {
      level = json["level"];
    }
    //icon
    if (json["icon"] != null) {
      icon = json["icon"];
    }
    //title
    title = json['title'];
    //subtitle
    subtitle = json['subtitle'];
    //children
    if (json['children'] != null) {
      children.clear();
      //for each entry from json children add to the Node children
      json['children'].forEach((v) {
        children.add(Menu.fromJson(v));
      });
    }
  }
}
