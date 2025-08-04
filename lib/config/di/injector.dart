import 'package:get_it/get_it.dart';

import 'package:campus_life_hub/features/schedule/di/schedule_di.dart';
import 'package:campus_life_hub/features/course/di/course_di.dart';


final GetIt sl = GetIt.instance;

Future<void> init() async {
  await registerScheduleDI();
  await registerCourseDI();
}