import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:shahed/models/image.dart';
import 'package:shahed/provider/event_provider.dart';
import 'package:shahed/shared_data/shareddata.dart';
import 'package:shahed/widgets/custom_modal_bottomsheet.dart';

class PickImages extends StatefulWidget {
  int ?count;

  List ?updateList;

  PickImages({this.count, this.updateList});

  @override
  _PickImagesState createState() => _PickImagesState();
}

class _PickImagesState extends State<PickImages> {
  ImagePicker _picker = ImagePicker();

  int subValue = 0;
  List? images = [];
  static List<XFile> _imageFile = <XFile>[];

  @override
  void initState() {
    super.initState();

    if (widget.count != null && widget.count! > 0) {
      int? total = widget.count;

      if (total! < 4 && total! > 0) {
        subValue = (total - 4) * -1;
      }
      setState(() {
        for (int index = 1; index <= total; index++) {
          images!.add("Add Image");
        }
        for (int index = 1; index <= subValue; index++) {
          images!.add("Add Image");
        }
      });
    } else {
      setState(() {
        images!.add("Add Image");
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
      children: List.generate(images!.length, (index) {
        if (widget.count != null && index < widget.updateList!.length) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.updateList![index],
                  height: 300,
                  width: 300,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      FontAwesomeIcons.xmark,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        Provider.of<EventProvider>(context, listen: false)
                            .event
                            .dropValue(index);

                        if ((images!.length >= 2) && (images!.length <= 4)) {
                          // images.replaceRange(index, index + 1, ['Add Image']);
                          images!.removeAt(index);
                        } else {
                          images!.replaceRange(index, index + 1, ['Add Image']);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (images![index] is ImageModel) {
          ImageModel uploadModel = images![index];

          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile!,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      FontAwesomeIcons.xmark,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        Provider.of<EventProvider>(context, listen: false)
                            .event
                            .dropValue(index);

                        if ((images!.length >= 2) && (images!.length <= 4)) {
                          // images.replaceRange(index, index + 1, ['Add Image']);
                          images!.removeAt(index);
                        } else {
                          images!.replaceRange(index, index + 1, ['Add Image']);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return InkWell(
            onTap: () {
              if (images!.length >= 1 && images!.length <= 4) {
                // _showPicker(context,index);
                showPicker(context, _imgFromGallery, _imgFromCamera,
                    index: index);
              } else {
                // we can put a message here if the list is full.
              }
            },
            child: Container(
              color: Colors.black54,
              margin: EdgeInsets.all(2),
              child: Column(
                // spacing: 2,
                // runSpacing: -10,
                // alignment: WrapAlignment.center,
                // crossAxisAlignment: WrapCrossAlignment.center,
                // direction: Axis.horizontal,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 24,
                  ),
                  FittedBox(
                    child: Text(
                      SharedData.getGlobalLang().pickImage(),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  )
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Future _imgFromGallery(int index) async {
    XFile? file =
        await _picker.pickImage(source: ImageSource.gallery , imageQuality: 75);
    if (file != null) {
      _imageFile.add(file);
      if (_imageFile[index].path != "")
        setState(() {
          Provider.of<EventProvider>(context, listen: false).event.setXFile =
              _imageFile;
          getFileImage(index);
          if (index < 3) images!.add("Add Image");
        });
    }
  }

  Future _imgFromCamera(int index) async {
    XFile? file =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    if (file != null) {
      _imageFile.add(file);
      if (_imageFile[index] != null) if (_imageFile[index].path != "")
        setState(() {
          Provider.of<EventProvider>(context, listen: false).event.setXFile =
              _imageFile;
          getFileImage(index);
          if (index < 3) images!.add("Add Image");
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
      images!.replaceRange(index, index + 1, [imageUpload]);
    });
  }
}
