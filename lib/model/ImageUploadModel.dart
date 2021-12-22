import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageModel {
    bool isUploaded;
     bool uploading;
      File imageFile;
    String imageUrl;

  ImageModel({ isUploaded,
     uploading,
     imageFile,
      imageUrl,}

  );
}