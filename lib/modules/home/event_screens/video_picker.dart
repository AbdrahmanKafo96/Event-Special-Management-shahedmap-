import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/widgets/custom_modal_bottomsheet.dart';
import 'package:shahed/widgets/custom_toast.dart';
import 'package:video_player/video_player.dart';

class VideoPicker extends StatefulWidget {
  String oldVideo = "";
  int eventID;

  VideoPicker({this.oldVideo, this.eventID});

  @override
  _VideoPickerState createState() => _VideoPickerState();
}

class _VideoPickerState extends State<VideoPicker> {
  VideoPlayerController _controller;
  XFile video;

  ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.oldVideo != null && widget.oldVideo != "none")
      setState(() {
        _controller = VideoPlayerController.network('${widget.oldVideo}')
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
      });
  }

  var images;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: widget.oldVideo != "none" &&
              widget.oldVideo != null &&
              _controller != null
          ? AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Stack(
                //  fit: StackFit.loose,
                alignment: Alignment.center,
                children: <Widget>[
                  VideoPlayer(
                    _controller,
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.xmark,
                        size: 28,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Provider.of<EventProvider>(context, listen: false)
                            .removeVideo(widget.eventID);
                        // this for remove video ... we need it in view screen.
                        setState(() {
                          Provider.of<EventProvider>(context, listen: false)
                              .event
                              .setVideoFile = null;
                          _controller = null;
                        });
                      },
                    ),
                  ),
                  Material(
                      type: MaterialType.transparency,
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        radius: 25,
                        onTap: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        splashColor: Colors.grey,
                        highlightColor: Colors.grey,
                        child: Container(
                          width: 34,
                          height: 34,
                          child: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ))
                ],
              ),
            )
          : _controller == null
              ? AspectRatio(
                  aspectRatio: 16.0 / 9.0,
                  child: InkWell(
                    child: customUploadVideo(),
                    onTap: () {
                      showPicker(context, _imgFromGallery, _imgFromCamera);
                    },
                  ),
                )
              : AspectRatio(
                  aspectRatio: 16.0 / 9.0,
                  child: Stack(
                    //  fit: StackFit.loose,
                    alignment: Alignment.center,
                    children: <Widget>[
                      VideoPlayer(_controller),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.xmark,
                            size: 28,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              _controller = null;
                              Provider.of<EventProvider>(context, listen: false)
                                  .event
                                  .setVideoFile = null;
                              //   }else{
                              //     images.replaceRange(index, index + 1, ['Add Image']);
                              //   }
                            });
                          },
                        ),
                      ),
                      Material(
                          type: MaterialType.transparency,
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.withOpacity(0.5),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            radius: 25,
                            onTap: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            splashColor: Colors.grey,
                            highlightColor: Colors.grey,
                            child: Container(
                              width: 34,
                              height: 34,
                              child: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) _controller.dispose();
  }

  _imgFromGallery() async {
    XFile videofile = await _picker.pickVideo(source: ImageSource.gallery);
    if (videofile == null) {
      return;
    } else {
      File file = File(videofile.path);

      if (file.lengthSync() < 10000000) {
        setState(() {
          _controller = VideoPlayerController.file(file)
            ..initialize().then((_) {});
          Provider.of<EventProvider>(context, listen: false)
              .event
              .setVideoFile = file;
        });
      } else {
        showShortToast(SharedData.getGlobalLang().alertSizeFile(), Colors.orange);
      }
    }
  }

  Future _imgFromCamera() async {
    XFile videofile = await _picker.pickVideo(source: ImageSource.camera);

    if (videofile == null) {
      return;
    } else {
      File file = File(videofile.path);
      print("file path  ${file.path}");
      print("file.lengthSync() ${file.lengthSync()}");
      if (file.lengthSync() < 10000000) {
        //10MB
        setState(() {
          _controller = VideoPlayerController.file(file)
            ..initialize().then((_) {});
          Provider.of<EventProvider>(context, listen: false)
              .event
              .setVideoFile = file;
        });
      } else {
        showShortToast(SharedData.getGlobalLang().alertSizeFile(), Colors.orange);
      }
    }
  }

  Widget customUploadVideo() {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        //  side: BorderSide(color: Colors.gr, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      color: Color(0xff424250),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: 100,
                child: Card(
                  elevation: 0.5,
                  color: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    //  side: BorderSide(color: Colors.gr, width: 1),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                  ),
                  child: Icon(
                    FontAwesomeIcons.upload,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    SharedData.getGlobalLang().addVideo(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                      SharedData.getGlobalLang().pickVideo(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
