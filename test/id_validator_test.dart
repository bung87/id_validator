import 'package:test/test.dart';
import 'package:id_validator/id_validator.dart';

void main() {
  test('isValid false', () {
    expect(CnIdValidator("345955198706122245").isValid(), false);
  });
  test('isValid true', () {
    expect(CnIdValidator("371001198010082394").isValid(), true);
  });
  test('old isValid true', () {
    expect(CnIdValidator("431389760616601").isValid(), true);
  });
}
