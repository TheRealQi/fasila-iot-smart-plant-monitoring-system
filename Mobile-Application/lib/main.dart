import 'package:fasila/colors.dart';
import 'package:fasila/controllers/authentication_controller.dart';
import 'package:fasila/controllers/connectivity_controller.dart';
import 'package:fasila/shared_pref.dart';
import 'package:fasila/views/authentication_page.dart';
import 'package:fasila/views/home.dart';
import 'package:fasila/views/initial_loading_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'controllers/notifications_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await CacheHelper.onInit();
  Get.put(NotificationController());
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ConnectivityController());
  Get.put(AuthenticationController());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    Builder(
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        var token = CacheHelper.getDataFromSharedPrefrence('token');
        return GetMaterialApp(
          title: 'FASILA',
          defaultTransition: Transition.rightToLeft,
          theme: ThemeData(
              fontFamily: 'Inter',
              scaffoldBackgroundColor: Colors.transparent,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: AppColor.primary,
                cursorColor: AppColor.primary,
                selectionHandleColor: AppColor.primary,
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: AppColor.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: AppColor.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: AppColor.primary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(
                  fontSize: 18.sp,
                  color: AppColor.text,
                ),
                bodyMedium: TextStyle(
                  fontSize: 16.sp,
                  color: AppColor.text,
                ),
                bodySmall: TextStyle(
                  fontSize: 14.sp,
                  color: AppColor.text,
                ),
              )),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.appBar,
                        AppColor.background,
                      ],
                      stops: [0.7, 1.0],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: InitialLoadingScreen())),
        );
      },
    );
  }
}
