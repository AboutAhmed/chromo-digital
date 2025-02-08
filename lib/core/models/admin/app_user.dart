import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:chromo_digital/core/services/helper_function.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser extends Equatable {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? photoUrl;

  // final String phoneNumber;
  final DateTime createdAt;
  final String? password;

  const AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.photoUrl,
    this.password,
    // required this.phoneNumber,
    required this.createdAt,
  });

  AppUser copyWith({
    final String? uid,
    final String? firstName,
    final String? lastName,
    final String? email,
    final String? photoUrl,
    // final String? phoneNumber,
    final DateTime? createdAt,
    final String? password,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      // phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      password: password ?? this.password,
    );
  }

  // create constructor
  factory AppUser.create({
    // required final String uid,
    required final String firstName,
    required final String lastName,
    required final String email,
    required final String password,
    // required final String phoneNumber,
  }) {
    return AppUser(
      uid: '',
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      // phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
    );
  }

  // skeleton
  factory AppUser.skeleton() {
    return AppUser(
      uid: HelperFunction.generateString(max: 28, min: 27),
      firstName: HelperFunction.generateString(max: 8, min: 3),
      lastName: HelperFunction.generateString(max: 8, min: 3),
      email: HelperFunction.generateString(max: 20, min: 15),
      password: HelperFunction.generatePassword(),
      // phoneNumber: '1234567890',
      createdAt: DateTime.now(),
    );
  }

  factory AppUser.loggedOut() {
    return AppUser(
      uid: '',
      firstName: '',
      lastName: '',
      email: '',
      password: '',
      // phoneNumber: '',
      createdAt: DateTime.now(),
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  @override
  List<Object?> get props => [uid];
}
