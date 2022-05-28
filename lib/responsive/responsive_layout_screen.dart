import 'package:flutter/material.dart';
import 'package:highin_app/utils/global_variables.dart';

class ResponsiveLayout extends StatelessWidget{
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({
    Key? key, required this.webScreenLayout, required this.mobileScreenLayout, }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth> webScreenSize){
          return webScreenLayout;
          //for web screen
        }
        return mobileScreenLayout;
        //for mobile screen

      },
    );
  }
}