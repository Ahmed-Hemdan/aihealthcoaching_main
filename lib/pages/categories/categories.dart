
import 'package:aihealthcoaching_main/models/indices.dart';
import 'package:aihealthcoaching_main/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/shimmer/shimmer_list.dart';
import '../../generated/l10n.dart';
import 'single_category.dart';
import '../../utils/helper_api.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  HelperApi helperApi = new HelperApi();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    helperApi.getIndicies(auth.token ?? "");
    return FutureBuilder<List<IndicesModel>>(
      future: helperApi.getIndicies(auth.token ?? ""),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text('No Connection'),
            );
           
          case ConnectionState.waiting:
          case ConnectionState.active:
            return ShimmerList();
          case ConnectionState.done:
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? CategoriesList(indicesModel: snapshot.data)
                : ShimmerList();
          
        }
        
      },
    );
  }
}

class CategoriesList extends StatelessWidget {
  late final List<IndicesModel> indicesModel;

  CategoriesList({Key? key, required this.indicesModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.indices,),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: indicesModel.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      elevation: 0.9,
                      child: InkWell(
                        onTap: () {
                          _gotoSingleCategory(indicesModel[index], context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              FadeInImage(
                                  image: indicesModel[index].image == null
                                      ? AssetImage('assets/images/logo2.png')
                                      : NetworkImage(indicesModel[index].image ?? "") as ImageProvider,
                                  placeholder:
                                      AssetImage('assets/images/logo2.png')),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  indicesModel[index].name ?? "",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _gotoSingleCategory(IndicesModel indicesModel, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SingleCategory(indicesModel)),
    );
  }
}
