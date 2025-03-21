import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomMonthOnlyPicker extends DatePickerModel {
  CustomMonthOnlyPicker(
      {DateTime? currentTime,
      DateTime? minTime,
      DateTime? maxTime,
      LocaleType? locale})
      : super(
            locale: locale,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [0, 1, 0];
  }
}
