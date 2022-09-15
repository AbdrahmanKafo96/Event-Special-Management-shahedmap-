import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
// import 'package:systemevents/widgets/customToast.dart';
import 'package:systemevents/models/image.dart';
import 'package:systemevents/provider/event_provider.dart';

class MyCustomImage extends StatefulWidget {
  int count;

  List updateList = [];
  int  eventID;
  MyCustomImage({this.count, this.updateList , this.eventID});

  @override
  _MyCustomImageState createState() => _MyCustomImageState();
}

class _MyCustomImageState extends State<MyCustomImage> {
  ImagePicker _picker = ImagePicker();

  void _showPicker(context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('مكتبة الصور'),
                        onTap: () {
                          _imgFromGallery(index);
                          Navigator.of(context).pop();
                        }),
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('الكميرا'),
                      onTap: () {
                        _imgFromCamera(index);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  int subValue = 0;
  List images = List.filled(4, null);
  List<XFile> _imageFile = List.filled(4, null);

  @override
  void initState() {
    super.initState();

    if (widget.count != null && widget.count > 0) {
      int total = widget.count;

      if (total < 4 && total > 0) {
        subValue = (total - 4) * -1;
      }
      setState(() {
        for (int index = 0; index < total; index++) {
          images[index] = "Add Image";
        }
        // for(int index= 1 ; index <= subValue; index++){
        //   images[index]="Add Image";
        // }
      });
    } else {
      setState(() {
        images[0] = "Add Image";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: buildGridView(),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {

        if (images.elementAt(index)is ImageModel) {
          ImageModel uploadModel = images[index];

          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      FontAwesomeIcons.remove,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {

                        images[index]='removed';

                         Provider.of<EventProvider>(context, listen: false)
                             .removeImage(widget.eventID , index);


                        // print(images.length);
                        // if ((images.length >= 2) && (images.length <= 4)) {
                        //   // images.replaceRange(index, index + 1, ['Add Image']);
                        //   images.removeAt(index);
                        // } else {
                        //   images.replaceRange(index, index + 1, ['Add Image']);
                        //}
                      });
                    },
                  ),
                ),
              ],
            ),
          );}
       else if (widget.count != null && images[index] != "removed" &&
            index < widget.updateList.length &&  widget.updateList.elementAt(index) is String  ) {

          return   Card(
              clipBehavior: Clip.antiAlias,
              child:
              Stack(children: <Widget>[
                Image.network(
                  widget.updateList[index],
                  height: 300,
                  width: 300,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      FontAwesomeIcons.remove,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {

                      setState(() {
                        Provider.of<EventProvider>(context, listen: false).removeImage(widget.eventID ,index);
                        images[index] = "removed";


                      });
                     // Provider.of<EventProvider>(context, listen: false).event.getXFile[index]=null;
                    },
                  ),
                )
              ]));


        } else {
          return Card(
            color: Colors.black54,
            elevation: 5.0,
            child: Wrap(
              spacing: 2,
              runSpacing: -10,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: [
                IconButton(
                  icon: Icon(Icons.add_photo_alternate,color: Colors.white,size: 26,),
                  onPressed: () {

                    // if (images.length >= 1 && images.length <= 4) {

                      _showPicker(context, index);
                    // } else {
                    //   // we can put a message here if the list is full.
                    // }
                  },
                ),
                Text(
                  "اختر صورة",
                  style: Theme.of(context).textTheme.subtitle2,
                )
              ],
            ),
          );
        }
      }),
    );
  }



  Future _imgFromGallery(int index) async {
    XFile file = await _picker.pickImage(source: ImageSource.gallery , imageQuality: 75);
    if (file != null) {

      _imageFile[index] = file;

      if (_imageFile[index].path != "")
        setState(() {
          Provider.of<EventProvider>(context, listen: false).event.setXFile =
              _imageFile;

          getFileImage(index);

        });
    }
  }

  Future _imgFromCamera(int index) async {
    XFile file = await _picker.pickImage(source: ImageSource.camera , imageQuality: 75);
    if (file != null) {
      _imageFile[index] = file;
      if (_imageFile[index].path != "")
        setState(() {
          Provider.of<EventProvider>(context, listen: false).event.setXFile =
              _imageFile;
          getFileImage(index);

        });
    }
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();

    setState(() {
      ImageModel imageUpload = new ImageModel();
      imageUpload.isUploaded = false;
      imageUpload.uploading = false;
      imageUpload.imageFile = File(_imageFile[index].path);
      imageUpload.imageUrl = '';
      images[index] =  imageUpload ;
    });
    
  }
}
