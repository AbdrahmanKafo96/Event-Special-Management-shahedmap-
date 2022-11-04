// // import 'dart:io';
// import 'package:mockito/annotations.dart';
// import 'package:shahed/provider/event_provider.dart';
// import 'package:test/test.dart';
// // import 'package:image_picker/image_picker.dart';
//
// @GenerateMocks([EventProvider])
// void main() {
//   group('This is a test to send the event to the back side.', () {
//     EventProvider obj;
//     Map collection = Map();
//     test('create obj', () {
//       obj=EventProvider();
//       expect(obj, obj);
//     });
//     test('insert data', () async{
//      // obj.event.setEventName="سرقة سيارة";
//       obj.event.setDescription="سرقة سيارة امام المنزل";
//       obj.event.setLat= 32.8120;
//       obj.event.setLng= 13.0136;
//      String authorization="19|egX6dxDue5DDYccAT3BKDa28MCziiIPHxYy2coZh";
//       collection={
//       //  "event_name":obj.event.getEventName.toString(),
//         "description":obj.event.getDescription.toString(),
//         "lat":obj.event.getLat.toString(),
//         "lng":obj.event.getLng.toString(),
//         "sender_id":86.toString(),
//         "eventtype":38.toString(),
//         "senddate":"2022-3-4",
//         'Authorization':authorization
//       };});
//     test('send data to the backend side', ()async {
//   //    expect(await obj.testAddEvent(collection), true);
//     //  print('success');
//     });
//   });
//
//
// }