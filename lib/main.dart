import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/views/entry_point.dart';

Widget defaultHome = MainScreen();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 825),
      minTextAdapt: true,
      splitScreenMode: false,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return GetMaterialApp(
          theme: ThemeData(
            splashColor: Colors.transparent,
            scaffoldBackgroundColor: kWhite,
          ),
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
      child: defaultHome,
    );
  }
}
