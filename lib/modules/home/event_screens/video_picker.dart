import
'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/widgets/custom_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/widgets/custom_toast.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';



// class ExtraMedia extends StatefulWidget {
//   @override
//   State<ExtraMedia> createState() => _ExtraMediaState();
// }
//
// class _ExtraMediaState extends State<ExtraMedia> {
//   final picker = ImagePicker();
//  File _video;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(height: 40,),
//         TextButton.icon(
//             icon: Icon(Icons.upload_file),
//             label:  Text("ارفاق وسائط متعددة" ,style:TextStyle(fontWeight: FontWeight.bold) ,),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return Directionality(
//                     textDirection: TextDirection.rtl,
//                     child: AlertDialog(
//                       // scrollable: true,
//                         title: Text('إضافة وسائط متعددة'),
//                         content: Padding(
//                           padding: const EdgeInsets.all(1),
//                           child: Container(
//                             child: Container(
//                               // padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
//                               child: GridView.count(
//                                 shrinkWrap: true,
//                                 crossAxisCount: 2,
//                                 //  padding: EdgeInsets.all(3.0),
//                                 children: <Widget>[
//                                   dashboardItem("تسجيل صوتي", Icons.keyboard_voice ,2 ),
//                                   dashboardItem("تحديد الموقع", Icons.add_location_alt ,4,context: context   ),
//                                   dashboardItem("فيديو مرئي", Icons.video_collection,1 ),
//                                   // dashboardItem("حول التطبيق", Icons.info,'About'),
//
//                                 ],
//                               ),
//                             ),
//                           ),
//
//                         )
//                     ),
//                   );
//                 },
//               );}),
//       ],
//     );
//   }
//
//   Widget  dashboardItem(String title, IconData icon , int id
//       ,{BuildContext context}) {
//     return InkWell(
//       //highlightColor: Colors.blueGrey,
//       //hoverColor: Colors.black,
//         onTap: () {
//           if(id==4){
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MapPage()),
//             );
//           }
//           if(id==1){
//
//             _videoFromCamera();
//           }else{
//
//           }
//         },
//         child: customCard(icon ,title)
//     );
//   }
//
//   _videoFromCamera() async {
//
//     final video =
//     await picker.getVideo(source: ImageSource.camera,);
//     setState(() {
//       _video = File(video.path);
//
//       Provider.of<EventProvider>(context, listen: false).event.setVideoFile = _video;
//
//     });
//   }
// }
class VideoPicker extends StatefulWidget {
  String oldVideo="";
  int eventID;
  VideoPicker({this.oldVideo , this.eventID});

  @override
  _VideoPickerState createState() => _VideoPickerState();
}

class _VideoPickerState extends State<VideoPicker> {
    VideoPlayerController  _controller;
  XFile  video ;
  ImagePicker _picker = ImagePicker();
  void _showPicker(context  ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('مكتبة الصور'),
                    onTap: () {
                      _imgFromGallery( );
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('الكميرا'),
                  onTap: () {
                    _imgFromCamera( );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
  @override
  void initState() {
    super.initState();

    if(  widget.oldVideo!=null  && widget.oldVideo!="none")
    setState(() {

      _controller = VideoPlayerController.network(
          '${widget.oldVideo}')

        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    });
  }
  var images;
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: InkWell(
        onTap: (){
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: widget.oldVideo!="none" && widget.oldVideo!=null &&_controller!=null?
        AspectRatio(
          aspectRatio:
          16.0/9.0 ,
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
                    FontAwesomeIcons.remove,
                    size: 28,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Provider.of<EventProvider>(context, listen: false).removeVideo(widget.eventID);
                    // this for remove video ... we need it in view screen.
                    setState(() {
                      Provider.of<EventProvider>(context, listen: false).event.setVideoFile = null;
                      _controller=null;

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
                    onTap: (){
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
                      child: Icon(  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white,),
                    ),
                  ))
            ],
          ),

        ) :
         _controller==null?AspectRatio(
          aspectRatio:
          16.0/9.0 ,
          child:
          InkWell(
            child:customUploadVideo(),
              onTap: (){
            _showPicker(context  );
          },)
          ,

        ):
        AspectRatio(
          aspectRatio:
          16.0/9.0 ,
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
                    FontAwesomeIcons.remove,
                    size: 28,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {


                      _controller=null;
                      Provider.of<EventProvider>(context, listen: false).event.setVideoFile = null;
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
                    onTap: (){
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
                      child: Icon(  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white,),
                    ),
                  ))
            ],
          ),

        ),
      ),


    );
  }

  @override
  void dispose() {
    super.dispose();
    if(_controller!=null)
    _controller.dispose();
  }

  Future _imgFromGallery( ) async {
    XFile  videofile= await _picker.pickVideo(source: ImageSource.gallery
        //,maxDuration: Duration(minutes: 2)
        );
    // MediaInfo mediaInfo = await VideoCompress.compressVideo(
    //   videofile.path,
    //   quality:VideoQuality.LowQuality,
    //   deleteOrigin: false, // It's false by default
    // );

    if (videofile==null){
      return;
    }
    else{
       File file = File(videofile.path);
       if(file.lengthSync() <10000000){
         setState(() {
           _controller = VideoPlayerController.file(
               file)
             ..initialize().then((_) {
             });
           Provider.of<EventProvider>(context, listen: false).event.setVideoFile = file;
         });
       }else{
         showShortToast("حجم الملف اكبر من 10 ميجا", Colors.orange);
       }
    }

  }
  Future  _imgFromCamera( ) async {
    XFile   videofile=await _picker.pickVideo(source: ImageSource.camera ,maxDuration: Duration(minutes: 2));
    // MediaInfo mediaInfo = await VideoCompress.compressVideo(
    //   videofile.path,
    //   quality:VideoQuality.LowQuality,
    //   deleteOrigin: false, // It's false by default
    // );
    if (videofile==null){
      return;
    }
    else{
      File file = File(videofile.path);
      if(file.lengthSync() <10000000){//10MB
        setState(() {
          _controller = VideoPlayerController.file(
              file)
            ..initialize().then((_) {
            });
          Provider.of<EventProvider>(context, listen: false).event.setVideoFile = file;
        });
      }else{
        showShortToast("حجم الملف اكبر من 10 ميجا", Colors.orange);
      }
    }
  }
  Widget customUploadVideo(){
    return Card(

      elevation: 1.0,
      shape:  RoundedRectangleBorder(
        //  side: BorderSide(color: Colors.gr, width: 1),
        borderRadius: BorderRadius.all(
            Radius.circular(5)
           ),
      ),
       color:  Color(0xff212121),
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
                  shape:  RoundedRectangleBorder(
                    //  side: BorderSide(color: Colors.gr, width: 1),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                  ),
                  child: Icon( FontAwesomeIcons.upload,color: Colors.white ,),
                ),
              ),),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment:MainAxisAlignment.start,
                children: [
                  Text(
                    "اضف فيديو",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    "قم بالتقاط فيديو للحادثة",
                    style: Theme.of(context).textTheme.subtitle2,
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
