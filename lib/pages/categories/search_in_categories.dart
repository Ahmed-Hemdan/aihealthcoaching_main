

import 'package:aihealthcoaching_main/generated/l10n.dart';
import 'package:aihealthcoaching_main/widgets/shimmer/shimmer_list.dart';

import '../../models/post_model.dart';
import '../../pages/posts/single_post.dart';
import '../../providers/auth.dart';
import '../../utils/helper_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleCategoryInSearch extends StatefulWidget {
  final int? index;
  final String? title;
  SingleCategoryInSearch({Key? key, this.index, this.title}) : super(key: key);

  @override
  _SingleCategoryInSearchState createState() => _SingleCategoryInSearchState();
}

class _SingleCategoryInSearchState extends State<SingleCategoryInSearch> {
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
        title: Text(S.of(context)!.search),
        //title: Text(widget.title + widget.index.toString()),
        centerTitle: true,
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
        future: helperApi.getPostsForIndexsSearch(
            widget.index ?? 0, widget.title ?? "", auth.token ?? ""),
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
