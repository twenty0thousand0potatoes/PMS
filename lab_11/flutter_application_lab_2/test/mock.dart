import 'package:flutter_application_lab_2/model/jobs.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockJsonMap extends Mock implements Map<String, Object?> {}

void main() {
  group('Bakery', () {
    late Job job;
    late Map<String, Object?> mockJson;

    setUp(() {
      mockJson = MockJsonMap();
      when(mockJson['title']).thenReturn('get_up');
      when(mockJson['duration']).thenReturn('12');
      when(mockJson['category']).thenReturn('high');

      job = Job.fromJson(mockJson);
    });

    test('fromJson() should create a job object from JSON data', () {
      expect(job.title, 'get_up');
      expect(job.category, 'high');
    });

     test('toJson() should convert Worker object to JSON data', () {
      final json = job.toJson();
      expect(json['title'], 'get_up');
      expect(json['duration'], '12');
    });
  });
}
