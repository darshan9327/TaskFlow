import '../repositories/auth_repository.dart';

class GetUserDetailsUseCase {
  final UserRepository repository;
  GetUserDetailsUseCase(this.repository);

  Future<Map<String, dynamic>> execute(String uid) {
    return repository.getUserDetails(uid);
  }
}

class UpdateUserDetailsUseCase {
  final UserRepository repository;
  UpdateUserDetailsUseCase(this.repository);

  Future<void> execute(String uid, Map<String, dynamic> data) {
    return repository.updateUserDetails(uid, data);
  }
}
