import 'package:flutter/material.dart';
import '../utils/const.dart';

class CategoryList extends StatefulWidget {
  final int? id;
  const CategoryList({super.key,this.id});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        iconTheme: IconThemeData(color: PrimaryColor.colorWhite),
        title: widget.id ==2
        ?Text(
          'Mode of Payment',
          style: TextStyle(color: PrimaryColor.colorWhite),
        )
        :Text(
          'Categories',
          style: TextStyle(color: PrimaryColor.colorWhite),
        ),
        elevation: 5,
        backgroundColor: PrimaryColor.colorBottleGreen,
      ),
      body: widget.id ==0 
      ?ListView.builder(
        itemCount: ListOfAppData.listOfIncome.length,itemBuilder:(BuildContext context, int index){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: (){
              Navigator.pop(context,"$index");
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height*0.0748,
              width: 200,
              child: Row(
                children: [
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: Card(
                      color: PrimaryColor.colorBottleGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      child: ListOfAppData.listOfIncome[index].categoryIcon,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Text("${ListOfAppData.listOfIncome[index].categoryText}",style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 15),),
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
            child: SizedBox(
              height: MediaQuery.of(context).size.height*0.0748,
              width: 200,
              child: Row(
                children: [
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: Card(
                      color: PrimaryColor.colorBottleGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      child: ListOfAppData.listOfCategory[index].categoryIcon,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Text("${ListOfAppData.listOfCategory[index].categoryText}",style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 15),),
                ],
              ),
            ),
          ),
        );
      })      
    );
  }
}