import 'package:expenses_tracker/exports.dart';

class CategoryList extends StatefulWidget {
  final int? id;
  const CategoryList({super.key, this.id});

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
          title: Text(
            widget.id == 2 ? 'Mode of Payment' : 'Categories',
            style: TextStyle(color: PrimaryColor.colorWhite),
          ),
          elevation: 5,
          backgroundColor: PrimaryColor.colorBottleGreen,
        ),
        body: ListView.builder(
            itemCount: widget.id == 0
                ? ListOfAppData.listOfIncome.length
                : ListOfAppData.listOfCategory.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, "$index");
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.0748,
                    width: 200,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 55,
                          width: 55,
                          child: Card(
                            color: widget.id == 0
                                ? PrimaryColor.colorBottleGreen
                                : PrimaryColor.colorRed,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: widget.id == 0
                                ? ListOfAppData.listOfIncome[index].categoryIcon
                                : ListOfAppData
                                    .listOfCategory[index].categoryIcon,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.id == 0
                              ? "${ListOfAppData.listOfIncome[index].categoryText}"
                              : "${ListOfAppData.listOfCategory[index].categoryText}",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
