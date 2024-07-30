import 'dart:io';

import 'package:aihealthcoaching_main/generated/l10n.dart';
import 'package:aihealthcoaching_main/providers/auth.dart';
import 'package:aihealthcoaching_main/utils/helper_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:video_player/video_player.dart';

class AddPictureScreen extends StatefulWidget {
  const AddPictureScreen({Key? key}) : super(key: key);

  @override
  _AddPictureScreenState createState() => _AddPictureScreenState();
}

class _AddPictureScreenState extends State<AddPictureScreen> {
  HelperApi helperApi = new HelperApi();

  String? weight;

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final ImagePicker _picker = ImagePicker();

  var image;

  Future<void> _playVideo(PickedFile file) async {
    if (mounted) {
      await _disposeVideoController();
      VideoPlayerController controller;
      if (kIsWeb) {
        // ignore: deprecated_member_use
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;
      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      final double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      setState(() {});
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext? context}) async {
    if (_controller != null) {
      await _controller?.setVolume(0.0);
    }

    try {
      var _pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      
   
      setState(() {
        image = _pickedImage?.path;
      });
    } catch (e) {
      print("Error while picking image" + e.toString());
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller?.setVolume(0.0);
      _controller?.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed?.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.add_picture),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add_a_photo_outlined, size: 60),
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery,
                        context: context);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            RoundedLoadingButton(
              
              child: Text('${S.of(context)!.add_picture}',
                  style: TextStyle(color: Colors.white)),
              controller: _btnController,
              onPressed: () async {
                if (image != null) {
                  var authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  var result = await helperApi.uploadImage(File(image),
                      authProvider.email ?? "", image, authProvider.token ?? "");
                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'The picture was uploaded successfully.',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error while uploading the picture.',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                    _btnController.reset();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please select picture.',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                  _btnController.reset();
                }
              },
              color: Colors.blue,
              borderRadius: 5.0,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
                // Using the file widget to show our image
                child: image != null
                    ? Center(child: Image.file(File(image)))
                    : Container()),
          ],
        ),
      ),
    );
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);
