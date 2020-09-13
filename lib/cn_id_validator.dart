import 'gb2260.dart';
import 'abstract_id_validator.dart';

enum IDType { oldVer, newVer }
const List<int> _PosWeight = [
  7,
  9,
  10,
  5,
  8,
  4,
  2,
  1,
  6,
  3,
  7,
  9,
  10,
  5,
  8,
  4,
  2
];

class CnIdValidator extends IDValidator {
  String id;
  IDType typ;
  bool checkPossibleAge;
  CnIdValidator(this.id, {this.checkPossibleAge = true}) {
    if (this.id.length == 15) {
      typ = IDType.oldVer;
    } else if (this.id.length == 18) {
      typ = IDType.newVer;
    }
  }
  @override
  bool isValid() {
    if (typ == null) {
      return false;
    }
    var addr = id.substring(0, 6);
    var len = id.length;
    var birth =
        typ == IDType.newVer ? id.substring(6, 14) : id.substring(6, 12);
    var order = typ == IDType.newVer
        ? id.substring(len - 3, len - 1)
        : id.substring(len - 3);
    if (checkAddr(addr) == false ||
        checkBirth(birth) == false ||
        checkOrder(order) == false) {
      return false;
    }
    if (typ == IDType.oldVer) {
      return true;
    }

    var bodySum = 0;

    for (int j = 0; j < 17; j++) {
      int code = int.parse(id[j], radix: 10);
      if (code == null) {
        return false;
      }
      bodySum += code * _PosWeight[j];
    }
    var verBitNum = 12 - (bodySum % 11);
    String verBit;
    if (verBitNum == 10) {
      verBit = 'X';
    } else {
      verBit = "${verBitNum % 11}";
    }

    if (verBit.toString() != id[17].toUpperCase()) {
      return false;
    } else {
      return true;
    }
  }

  bool checkAddr(String addr) {
    int code = int.tryParse(addr);
    if (code == null) {
      return false;
    }
    if (GB2260.containsKey(code)) {
      return true;
    } else {
      String tmpAddr = addr.substring(0, 4) + "00";
      code = int.tryParse(tmpAddr);
      if (code == null) {
        return false;
      }
      if (GB2260.containsKey(code)) {
        return true;
      } else {
        tmpAddr = addr.substring(0, 2) + "0000";
        code = int.tryParse(tmpAddr);
        if (code == null) {
          return false;
        }
        if (GB2260.containsKey(code)) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  bool checkBirth(String birth) {
    int year, month, day;
    if (birth.length == 8) {
      year = int.tryParse(birth.substring(0, 4), radix: 10);
      month = int.tryParse(birth.substring(4, 6), radix: 10);
      day = int.tryParse(birth.substring(6), radix: 10);
    } else if (birth.length == 6) {
      year = int.tryParse('19' + birth.substring(0, 2), radix: 10);
      month = int.tryParse(birth.substring(2, 4), radix: 10);
      day = int.tryParse(birth.substring(4), radix: 10);
    } else {
      return false;
    }
    if (year == null || month == null || day == null) {
      return false;
    }
    int currentYear = DateTime.now().year;
    if (checkPossibleAge) {
      // world longest live
      if (currentYear - year > 134) {
        return false;
      }
    }
    if (year > currentYear) {
      return false;
    }
    if (month > 12 || month < 1 || day < 1 || day > daysInMonth(month, year)) {
      return false;
    }
    return true;
  }

  static int daysInMonth(int month, int year) {
    int days = 28 +
        (month + (month / 8).floor()) % 2 +
        2 % month +
        2 * (1 / month).floor();
    return (isLeapYear(year) && month == 2) ? 29 : days;
  }

  static bool isLeapYear(int year) =>
      ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0);

  bool checkOrder(String addr) {
    return true;
  }
}

main() {
  // dart --enable-asserts lib/cn_id_validator.dart
  assert(CnIdValidator("345955198706122245").isValid() == false);
  assert(CnIdValidator("371001198010082394").isValid() == true);
  assert(CnIdValidator("431389760616601").isValid() == true);
  assert(CnIdValidator("110108201008081427").isValid() == true);
  assert(CnIdValidator("11010119200913693X").isValid() == true);
  assert(CnIdValidator("110101192009137078").isValid() == true);
  assert(CnIdValidator("110101192009139110").isValid() == true);
  // month date not valid
  assert(CnIdValidator("110101192009319110").checkBirth("19200931") == false);
  // may not possible age
  assert(CnIdValidator("110101170009139110").checkBirth("17000913") == false);
  assert(CnIdValidator("110101170009139110", checkPossibleAge: false)
          .checkBirth("17000913") ==
      true);
}
