import 'package:floor/floor.dart';

class BaseEntity {
  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(nullable: false)
  final int id;

  @ColumnInfo(name: 'create_time', nullable: false)
  final String createTime;

  BaseEntity({this.id}) : createTime = DateTime.now().toString();
}
