class AccountHelper {
  static double sumData(
      {required List dataList,
      required String column,
      String? value,
      String? key}) {
    if (key != null && value != null) {
      return dataList
          .where((data) => data[key].toString() == value.toString())
          .toList()
          .map((data) => data[column])
          .reduce((prev, next) =>
              double.parse(prev.toString()) + double.parse(next.toString()));
    }
    return dataList.map((data) => data[column]).reduce((prev, next) =>
        double.parse(prev.toString()) + double.parse(next.toString()));
  }

  static double sumMultipleLists(
      {required List<List> dataList, required List<List<String>> columnsList}) {
    double total = 0;
    for (int i = 0; i < dataList.length; i++) {
      for (int subListIndex = 0;
          subListIndex < dataList[i].length;
          subListIndex++) {
        for (int j = 0; j < columnsList[i].length; j++) {
          total += double.parse(
              dataList[i][subListIndex][columnsList[i][j]].toString());
        }
      }
    }
    return total;
  }
}
