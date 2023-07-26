import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'check_model.g.dart';

@HiveType(typeId: 1)
class CheckModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String isSelected;
  @HiveField(2)
  final String? icon;

  CheckModel({
    required this.name,
    required this.isSelected,
    this.icon,
  });
  factory CheckModel.create({required String name}) {
    return CheckModel(name: name, isSelected: const Uuid().v1());
  }
  factory CheckModel.news({required String name, required String id}) {
    return CheckModel(name: name, isSelected: id);
  }
}
