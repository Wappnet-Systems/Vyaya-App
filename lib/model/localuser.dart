import 'package:expenses_tracker/exports.dart';

part 'localuser.g.dart';

@HiveType(typeId: 3)
class LocalUser extends HiveObject{
  
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String userName;

  
  @HiveField(2)
  final String userEmail;

  LocalUser({
    required this.userId,
    required this.userName,
    required this.userEmail,
  });
}
