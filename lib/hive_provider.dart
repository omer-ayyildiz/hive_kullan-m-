import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sil1/models/check_model.dart';

class HiveProvider extends ChangeNotifier {
  late Box<CheckModel> _checkModel;

  HiveProvider() {
    _checkModel = Hive.box<CheckModel>('modelVerisi');
  }
  //veri ekle
  Future<void> addData(CheckModel items) async {
    await _checkModel.put(items.isSelected, items);

    notifyListeners();
  }

  //veri getir
  Future<List<CheckModel>> getData() async {
    List<CheckModel> _allTask = [];
    _allTask = _checkModel.values.toList();
    return _allTask;
  }
}
