import 'package:flutter/material.dart';

import '../model/category.dart';
import '../utils/const.dart';

class CategoryList extends StatefulWidget {
  int? id;
  CategoryList({super.key,this.id});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: PrimaryColor.color_white),
        title: Text(
          'Categories',
          style: TextStyle(color: PrimaryColor.color_white),
        ),
        elevation: 5,
        backgroundColor: PrimaryColor.color_bottle_green,
      ),
      body: widget.id ==0 
      ?ListView.builder(
        itemCount: ListOfAppData.listofIncome.length,itemBuilder:(BuildContext context, int index){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: (){
              Navigator.pop(context,"$index");
            },
            child: Container(
              height: MediaQuery.of(context).size.height*0.0748,
              width: 200,
              child: Row(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    child: Card(
                      color: PrimaryColor.color_bottle_green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      child: ListOfAppData.listofIncome[index].categoryIcon,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("${ListOfAppData.listofIncome[index].categoryText}",style: TextStyle(color: PrimaryColor.color_black,fontSize: 15),),
                  // Text('${ListOfAppData.listOfCategory[index].categoryText}',style: TextStyle(color: PrimaryColor.color_black,fontSize: 15),),
                ],
              ),
            ),
          ),
        );
      })
      :ListView.builder(
        itemCount: ListOfAppData.listOfCategory.length,itemBuilder:(BuildContext context, int index){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: (){
              Navigator.pop(context,"$index");
            },
            child: Container(
              height: MediaQuery.of(context).size.height*0.0748,
              width: 200,
              child: Row(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    child: Card(
                      color: PrimaryColor.color_bottle_green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      child: ListOfAppData.listOfCategory[index].categoryIcon,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("${ListOfAppData.listOfCategory[index].categoryText}",style: TextStyle(color: PrimaryColor.color_black,fontSize: 15),),
                  // Text('${ListOfAppData.listOfCategory[index].categoryText}',style: TextStyle(color: PrimaryColor.color_black,fontSize: 15),),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}