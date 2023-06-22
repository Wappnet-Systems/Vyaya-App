import 'package:hive/hive.dart';

part 'userlogin.g.dart';

@HiveType(typeId: 0)
class UserLogin extends HiveObject{
  
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String userName;

  
  @HiveField(2)
  final String userEmail;

  @HiveField(3)
  final String userPhone;

  @HiveField(4)
  final String userToken;

  UserLogin({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userToken
  });
}