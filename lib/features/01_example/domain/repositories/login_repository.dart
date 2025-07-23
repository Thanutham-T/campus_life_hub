import 'package:campus_life_hub/core/resources/data_state.dart';
import '../entities/user_entity.dart';


abstract class LoginRepository {
  Future<DataState<UserEntity>> login(String email, String password);
}
