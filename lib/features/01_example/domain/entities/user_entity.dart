import 'package:equatable/equatable.dart';


class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String profilePictureUrl;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [id, name, email, phoneNumber, profilePictureUrl];
}
