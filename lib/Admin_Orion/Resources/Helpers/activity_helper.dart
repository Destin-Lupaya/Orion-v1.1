class ActivityHelper {
  static double sumData(
      {required List dataList,
      required String column,
      String? value,
      String? key}) {
    if (key != null && value != null) {
      return dataList
          .where((data) => data[key].toString() == value.toString())
          .map((data) => data[column])
          .reduce((prev, next) =>
              double.parse(prev.toString()) + double.parse(next.toString()));
    }
    return dataList.map((data) => data[column]).reduce((prev, next) =>
        double.parse(prev.toString()) + double.parse(next.toString()));
  }
}
