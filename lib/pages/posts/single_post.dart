import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:aihealthcoaching_main/pages/posts/pdf_viewer.dart';
import 'package:better_player/better_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/post_model.dart';
import 'package:flutter/material.dart';

class SinglePost extends StatefulWidget {
  //final Category category;
  final PostModel postModel;
  SinglePost(this.postModel);

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  var imageUrl;
  bool downloading = true;
  String downloadingStr = "No data";
  double download = 0.0;
  late File f;

  bool isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
  }

  changePDF(String fileUrl) async {
    setState(() => isLoading = true);
    document = await PDFDocument.fromURL(fileUrl);
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postModel.title ?? ""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: _buildPost(context),
        ),
      ),
    );
  }

  Widget _buildPost(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.postModel.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: Image.network(widget.postModel.image ?? ""),
                    )
                  : Container(),
              widget.postModel.title != null
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        widget.postModel.title ?? "",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(),
              widget.postModel.description != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 20.0, right: 20.0, left: 20.0),
                      child: Text(
                        widget.postModel.description ?? "",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                        softWrap: true,
                      ),
                    )
                  : Container(),
              widget.postModel.link != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 20.0, right: 20.0, left: 20.0),
                      child: InkWell(
                        child: new Text(
                          widget.postModel.link,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        onTap: () => launch(widget.postModel.link),
                      ),
                    )
                  : Container(),
              /*if (widget.postModel.file != null) Padding(padding: EdgeInsets.all(20),
              child: InkWell(
                child: Text('Download File'),
                onTap: _requestDownload,
              ),) else Container(),*/

              if (widget.postModel.file != null)
                Padding(
                  padding: EdgeInsets.all(20),
                  child: InkWell(
                    child: Text(
                      'Preview File',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff123456),
                      ),
                    ),
                    onTap: () {
                      _gotoSinglePost(widget.postModel.file ?? "", context);
                    },
                  ),
                )
              else
                Container(),
            ],
          ),
          widget.postModel.video != null
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer.network(
                    widget.postModel.video,
                    betterPlayerConfiguration: BetterPlayerConfiguration(
                      aspectRatio: 16 / 9,
                    ),
                  ),
                )
              : Center(
                  child: SizedBox(),
                ),
        ],
      ),
    );
  }

  void _gotoSinglePost(String url, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PDFScreen(
                fileUrl: url,
              )),
    );
  }
}
