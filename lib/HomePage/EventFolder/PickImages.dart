import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/CustomWidget/customToast.dart';
import 'package:systemevents/model/ImageUploadModel.dart';
import 'package:systemevents/provider/EventProvider.dart';

class PickImages extends StatefulWidget {
  int count ;
  List updateList;
  PickImages({this.count ,this.updateList});
  @override
  _PickImagesState createState() => _PickImagesState();
}

class _PickImagesState extends State<PickImages> {
//   File _image;
//   List<XFile> _imageFileList ;
//   List<Asset> images = List<Asset>();
  ImagePicker _picker = ImagePicker();


  void _showPicker(context ,int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('مكتبة الصور'),
                        onTap: () {
                          _imgFromGallery(index);
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('الكميرا'),
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
  int subValue=0;
  List images =  [];
  static List<XFile> _imageFile = <XFile>[];
  @override
  void initState() {
    super.initState();

    if(widget.count!=null && widget.count>0)
    {
      int total=widget.count;

      if(total<4 && total>0) {
        subValue=(total-4)*-1;

      }


      setState(() {
        for(int index= 1 ; index <= total; index++){
          images.add("Add Image");
        }
        for(int index= 1 ; index <= subValue; index++){
          images.add("Add Image");
        }
      });
    }
    else{
      setState(() {
        images.add("Add Image");
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
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
      childAspectRatio:1,

      children: List.generate(images.length, (index) {


        if(widget.count!=null && index <widget.updateList.length){
          return   Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.network(widget.updateList[index],height: 300,width: 300, fit: BoxFit.fill,) ,

                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        Provider.of<EventProvider>(context, listen: false).event.dropValue(index);
                        print(images.length);
                        if((images.length>=2 )&& (images.length<=4)){
                          // images.replaceRange(index, index + 1, ['Add Image']);
                          images.removeAt(index);
                        }else{
                          images.replaceRange(index, index + 1, ['Add Image']);
                        }
                      });
                    },
                  ),
                ),


              ],
            ),
          )  ;
        }
        else if (images[index] is ImageModel) {
          ImageModel  uploadModel = images[index];

          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[

                Image.file(
                  uploadModel.imageFile  ,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        Provider.of<EventProvider>(context, listen: false).event.dropValue(index);
                        print(images.length);
                        if((images.length>=2 )&& (images.length<=4)){
                          // images.replaceRange(index, index + 1, ['Add Image']);
                          images.removeAt(index);
                        }else{
                          images.replaceRange(index, index + 1, ['Add Image']);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(

            elevation: 5.0,
            child: Wrap(
              spacing:2,
              runSpacing: -10,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: [
                IconButton(
                  icon: Icon(Icons.add_photo_alternate),
                  onPressed: () {
                    if(images.length>=1 && images.length<=4){
                      _showPicker(context,index);
                    }else{
                      // we can put a message here if the list is full.
                    }
                  },
                ),
                Text("اختر صورة",style: TextStyle(fontSize: 12),)
              ],
            ),
          );
        }
      }),
    );
  }


  Future _imgFromGallery(int index) async {

    XFile file= await _picker.pickImage(source: ImageSource.gallery);
    if(file!=null){
      _imageFile.add(file );
      if(_imageFile[index].path!="")
        setState(()    {
          Provider.of<EventProvider>(context, listen: false).event.setXFile=_imageFile;
          getFileImage(index);
          if(index<3)
            images.add("Add Image");
        });
    }

  }
  Future  _imgFromCamera(int index) async {
    XFile file=await _picker.pickImage(source: ImageSource.camera);
    if(file!=null){
      _imageFile.add( file);
      if(_imageFile[index]!=null)
        if(_imageFile[index].path!="")
          setState(() {
            Provider.of<EventProvider>(context, listen: false).event.setXFile=_imageFile;
            getFileImage(index);
            if(index<3)
              images.add("Add Image");

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
      images.replaceRange(index, index + 1, [imageUpload]);
    });


  }
}