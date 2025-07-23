import 'package:dio/dio.dart';

import 'package:campus_life_hub/core/resources/data_state.dart';
import 'package:campus_life_hub/features/01_example/domain/entities/user_entity.dart';
import 'package:campus_life_hub/features/01_example/domain/repositories/login_repository.dart';

import '../model/user_model.dart';


class LoginRepositoryImpl implements LoginRepository {
  final Dio _dio;

  LoginRepositoryImpl(this._dio);

  @override
  Future<DataState<UserEntity>> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        return DataSuccess(user);
      } else {
        return DataError(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return DataError(e);
      } else {
        return DataError(DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.unknown,
        ));
      }
    }
  }
}
