import 'package:aihealthcoaching_main/models/indices.dart';
import 'package:flutter/material.dart';
import '../../widgets/shimmer/shimmer_list.dart';
import '../../utils/custom_title.dart';
import '../../pages/categories/single_category.dart';

class WidgetCategories extends StatefulWidget {
  @override
  _WidgetCategoriesState createState() => _WidgetCategoriesState();
}

class _WidgetCategoriesState extends State<WidgetCategories> {
  late IndicesModel indicesModel;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: CustomTitle(title: "Explore", fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4, right: 4),
                child: Text(
                  'View All',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
          _categoriesList(),
        ],
      ),
    );
  }

  Widget _categoriesList() {
    return new FutureBuilder(builder: (BuildContext context, model) {
      if (model.hasData) {
        return _buildCategoryList(model.data as List<IndicesModel>?);
      }

      return ShimmerList();
    }, future: null,);
  }

  Widget _buildCategoryList(List<IndicesModel>? indicesModel) {
    return Container(
      height: 150,
      alignment: Alignment.topCenter,
      child: ListView.builder(
          itemCount: indicesModel?.length,
          itemBuilder: (BuildContext context, int index) {
            var data = indicesModel?[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      _gotoSingleCategory(indicesModel![index], context);
                    },
                    child: Image.network(
                      data?.image ?? "",
                      height: 80,
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 5),
                          blurRadius: 15,
                        ),
                      ]),
                ),
                Row(
                  children: [
                    Text(data?.name ?? ""),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 14,
                    )
                  ],
                ),
              ],
            );
          }),
    );
  }

  void _gotoSingleCategory(IndicesModel indicesModel, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SingleCategory(indicesModel)),
    );
  }
}
