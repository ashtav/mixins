import 'dart:math';

extension ListExtension on List {
  /// ```dart
  /// ['a', 'b', '4', 'e', '1'].getRandom() // 'e'
  /// ```
  dynamic getRandom([int length = 1]) {
    List result = [];
    for (int i = 0; i < length; i++) {
      result.add(this[Random().nextInt(this.length)]);
    }
    return result;
  }
}

extension ListMapExtension on List<Map> {
  /// ``` dart
  /// List<Map> group = data.groupBy('gender', wrapWith: (data){
  ///   return [...data.map((e) => YourModel.fromJson(e))];
  /// }, addKeys: ['gender']);
  /// ```
  List<Map<dynamic, dynamic>> groupBy(String key,
      {String? setKeyAs,
      Function(dynamic)? wrapWith,
      List<String> addKeys = const []}) {
    try {
      List<Map<dynamic, dynamic>> result = [];
      List keys = [];

      for (Map f in this) {
        keys.add(f[key]);

        if (!f.keys.toList().contains(key)) {
          return this;
        }
      }

      for (var k in [...keys.toSet()]) {
        List data = [...where((e) => e[key] == k)];
        Map map = {};

        if (addKeys.isNotEmpty) {
          for (var k in addKeys) {
            map[k] = data.first[k];
          }
        }

        if (wrapWith != null) {
          data = wrapWith(data);
        }

        if (setKeyAs != null) map['group_by'] = k;

        //remove key (group_by)
        //data.forEach((w) => w.removeWhere((k, v) => k == key));
        map[setKeyAs ?? k] = data;

        result.add(map);
      }

      return result;
    } catch (e) {
      throw Exception('$e');
    }
  }
}
