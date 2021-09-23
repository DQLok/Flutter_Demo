abstract class StringValidator{
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator{
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPAsswordValidators{
  final StringValidator emailValidator=NonEmptyStringValidator();
  final StringValidator passwordValidator=NonEmptyStringValidator();
  final String invalidEmailErrorText='Email can\'t be empty';
  final String invalidPassErrorText='Pass can\'t be empty';
}