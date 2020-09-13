# id_validator

中国大陆个人身份证号码验证器

Chinese Mainland Personal ID Card Validation

支持15位与18位身份证号
## Installation  
``` yaml
# pubspec.yaml
dependencies:
  # id_validator once this published to https://pub.dev
  id_validator:
    git:
      url: https://github.com/bung87/id_validator
```

## Usage

``` dart
import 'package:id_validator/id_validator.dart';
assert(CnIdValidator("371001198010082394").isValid() == true);
assert(CnIdValidator("431389760616601").isValid() == true);
// month date not valid
assert(CnIdValidator("110101192009319110").checkBirth("19200931") == false);
// may not possible age
assert(CnIdValidator("110101170009139110").checkBirth("17000913") == false);
assert(CnIdValidator("110101170009139110", checkPossibleAge: false)
          .checkBirth("17000913") ==
      true);
```
## License  
MIT  
