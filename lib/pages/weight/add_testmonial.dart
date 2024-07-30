// import 'dart:io';

// import 'package:aihealthcoaching/generated/l10n.dart';
// import 'package:aihealthcoaching/providers/auth.dart';
// import 'package:aihealthcoaching/utils/helper_api.dart'; 
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:video_player/video_player.dart';

// class TestmonialScreen extends StatefulWidget {
//   const TestmonialScreen({Key key}) : super(key: key);

//   @override
//   _TestmonialScreenState createState() => _TestmonialScreenState();
// }

// class _TestmonialScreenState extends State<TestmonialScreen> {
//   final _formKey = GlobalKey<FormState>();
//   HelperApi helperApi = new HelperApi();

//   String weight;

//   PickedFile _imageFile;
//   dynamic _pickImageError;
//   bool isVideo = false;
//   VideoPlayerController _controller;
//   VideoPlayerController _toBeDisposed;
//   String _retrieveDataError;
//   final RoundedLoadingButtonController _btnController =
//       RoundedLoadingButtonController();
//   final ImagePicker _picker = ImagePicker();
//   final TextEditingController maxWidthController = TextEditingController();
//   final TextEditingController maxHeightController = TextEditingController();
//   final TextEditingController qualityController = TextEditingController();

//   var video;

//   /*Future<void> _playVideo(PickedFile file) async {
//     if (file != null && mounted) {
//       await _disposeVideoController();
//       VideoPlayerController controller;
//       if (kIsWeb) {
//         controller = VideoPlayerController.network(file.path);
//       } else {
//         controller = VideoPlayerController.file(File(file.path));
//       }
//       _controller = controller;
//       // In web, most browsers won't honor a programmatic call to .play
//       // if the video has a sound track (and is not muted).
//       // Mute the video so it auto-plays in web!
//       // This is not needed if the call to .play is the result of user
//       // interaction (clicking on a "play" button, for example).
//       final double volume = kIsWeb ? 0.0 : 1.0;
//       await controller.setVolume(volume);
//       await controller.initialize();
//       await controller.setLooping(true);
//       await controller.play();
//       setState(() {});
//     }
//   }*/

//   void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
//     if (_controller != null) {
//       await _controller.setVolume(0.0);
//     }
//     if (isVideo) {
//       final PickedFile file = await _picker.getVideo(
//           source: source, maxDuration: const Duration(seconds: 10));
//       video = file.path;
//       //await _playVideo(file);
//     }
//   }

//   @override
//   void deactivate() {
//     if (_controller != null) {
//       _controller.setVolume(0.0);
//       _controller.pause();
//     }
//     super.deactivate();
//   }

//   @override
//   void dispose() {
//     _disposeVideoController();
//     maxWidthController.dispose();
//     maxHeightController.dispose();
//     qualityController.dispose();
//     super.dispose();
//   }

//   Future<void> _disposeVideoController() async {
//     if (_toBeDisposed != null) {
//       await _toBeDisposed.dispose();
//     }
//     _toBeDisposed = _controller;
//     _controller = null;
//   }

//   Future<void> retrieveLostData() async {
//     final LostData response = await _picker.getLostData();
//     if (response.isEmpty) {
//       return;
//     }
//     if (response.file != null) {
//       if (response.type == RetrieveType.video) {
//         isVideo = true;
//         //await _playVideo(response.file);
//       } else {
//         isVideo = false;
//         setState(() {
//           _imageFile = response.file;
//         });
//       }
//     } else {
//       _retrieveDataError = response.exception.code;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(S.of(context).add_testmonial),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Center(
//           child: Container(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Text(
//                             "I, voluntarily agree for marketing purposes to provide Ai Health Coaching with a testimonial regarding the services they have provided me and the results encountered by me. In no way have I been offered anything in return for the testimonial. The testimonial is my personal view to reflect the services of Ai Health Coaching.",
//                             style: TextStyle(
//                               fontSize: 20.0,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: <Widget>[
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           child: IconButton(
//                             icon: Icon(Icons.video_call_outlined),
//                             onPressed: () {
//                               isVideo = true;
//                               _onImageButtonPressed(ImageSource.gallery,
//                                   context: context);
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),
//                         /*StyledFlatButton(
//                           S.of(context).add_testmonial,
//                           onPressed: (){
//                             var authProvider = Provider.of<AuthProvider>(context, listen: false);
//                             helperApi.uploadVideo(File(video), authProvider.email, video, authProvider.token);
//                           },
//                         ),*/

//                         RoundedLoadingButton(
//                           child: Text('${S.of(context).add_testmonial}',
//                               style: TextStyle(color: Colors.white)),
//                           controller: _btnController,
//                           onPressed: () async {
//                             print("d");
//                             if (video != null) {
//                               print("dd");
//                               var authProvider = Provider.of<AuthProvider>(
//                                   context,
//                                   listen: false);

//                               var result = await helperApi.uploadVideo(
//                                   File(video),
//                                   authProvider.email,
//                                   video,
//                                   authProvider.token);
//                               print(result);

//                               if (result) {
//                                 _btnController.reset();
//                                 Navigator.pop(context);
//                               }
//                             } else {
//                               _btnController.reset();
//                             }
//                           },
//                           color: Colors.blue,
//                           borderRadius: 5.0,
//                           width: MediaQuery.of(context).size.width,
//                         ),
//                         SizedBox(
//                           height: 20.0,
//                         ),

//                         /*video != null ? AspectRatio(
//                           aspectRatio: 16 / 9,
//                           child: BetterPlayer.file(video,
//                             betterPlayerConfiguration: BetterPlayerConfiguration(
//                               aspectRatio: 16 / 9,
//                             ),
//                           ),
//                         ) : SizedBox(),*/
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// typedef void OnPickImageCallback(
//     double maxWidth, double maxHeight, int quality);

// class AspectRatioVideo extends StatefulWidget {
//   AspectRatioVideo(this.controller);

//   final VideoPlayerController controller;

//   @override
//   AspectRatioVideoState createState() => AspectRatioVideoState();
// }

// class AspectRatioVideoState extends State<AspectRatioVideo> {
//   VideoPlayerController get controller => widget.controller;
//   bool initialized = false;

//   void _onVideoControllerUpdate() {
//     if (!mounted) {
//       return;
//     }
//     if (initialized != controller.value.isInitialized) {
//       initialized = controller.value.isInitialized;
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(_onVideoControllerUpdate);
//   }

//   @override
//   void dispose() {
//     controller.removeListener(_onVideoControllerUpdate);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (initialized) {
//       return Center(
//         child: AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: VideoPlayer(controller),
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }
// }
