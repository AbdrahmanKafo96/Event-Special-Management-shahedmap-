import 'package:mockito/annotations.dart';
import 'package:systemevents/provider/event_provider.dart';
import 'package:test/test.dart';


@GenerateMocks([EventProvider])
void main() {

  group('This is a test to send the event to the back side.', () {
    EventProvider obj;
    test('create obj', () {
      obj=EventProvider();
      expect(obj, obj);
    });

    test('insert data', () {
      expect(string.trim(), equals('foo'));
    });
  });


}