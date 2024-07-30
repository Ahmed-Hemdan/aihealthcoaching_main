

import 'package:aihealthcoaching_main/pages/categories/search_index.dart';
import 'package:aihealthcoaching_main/widgets/shimmer/shimmer_list.dart';

import '../../models/indices.dart';
import '../../models/post_model.dart';
import '../../pages/posts/single_post.dart';
import '../../providers/auth.dart';
import '../../utils/helper_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleCategory extends StatefulWidget {
  final IndicesModel indicesModel;
  SingleCategory(this.indicesModel);

  @override
  _SingleCategoryState createState() => _SingleCategoryState();
}

class _SingleCategoryState extends State<SingleCategory> {

  HelperApi helperApi = new HelperApi();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.indicesModel.name ?? ""),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              //Navigator.pushNamed(context, '/search');
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchIndexScreen(index: widget.indicesModel.id,)));
            },
            icon: Image.asset(
              "assets/images/icons/search.png",
              fit: BoxFit.fill,
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            _productsList(),
          ],
        ),
      ),
    );
  }

  Widget _productsList() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Expanded(
      child: FutureBuilder<List<PostModel>>(
        future: helperApi.getPostsForIndexs(widget.indicesModel.id ?? 0, auth.token ?? ""),
        builder: (BuildContext context, AsyncSnapshot<List<PostModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text('No Connection'),
              );
            case ConnectionState.waiting:
            case ConnectionState.active:
              return ShimmerList();
            case ConnectionState.done:
              if (snapshot.hasError) {
                print(snapshot.error);
              }

              return snapshot.hasData
                  ? _buildProductList(snapshot.data!)
                  : ShimmerList();
          }
    
        },
      ),
    );
  }


  Widget _buildProductList(List<PostModel> postModel) {
    return ListView.builder(
      itemCount: postModel.length,
      itemBuilder: (BuildContext context, int index) {
        var data = postModel[index];
        return InkWell(
          onTap: () {
            _gotoSinglePost(postModel[index], context);
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: data.image != null
                        ? Image.network(
                      data.image ?? "",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    )
                        : Image.asset(
                      "assets/images/logo2.png",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.title ?? "",
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
        );
      },
    );
  }

  void _gotoSinglePost(PostModel postModel, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SinglePost(postModel)),
    );
  }
}
