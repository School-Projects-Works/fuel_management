import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fuel_management/features/driver/pages/driver_home_page.dart';
import 'package:fuel_management/router/router.dart';
import 'package:fuel_management/utils/colors.dart';
import 'core/local_storage.dart';
import 'features/driver/auth/login_page.dart';
import 'features/driver/auth/provider/driver_login_provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.initData();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context,WidgetRef ref) {
     if(kIsWeb) {
       return MaterialApp.router(
         title: 'AAMUSTED TRANSPORT',
         debugShowCheckedModeBanner: false,
         theme: ThemeData(
           colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
           useMaterial3: true,
         ),
         builder: FlutterSmartDialog.init(),
         routerConfig: MyRouter(context: context,ref: ref).router(),
       );
     }else{
       return MaterialApp(
         title: 'AAMUSTED TRANSPORT',
          debugShowCheckedModeBanner: false,
         theme: ThemeData(
           colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
         ),
         builder: FlutterSmartDialog.init(),
         home:ref.watch(driverProvider)!=null? const DriverHomePage(): const DriverLogin(),
       );
     }

  }
}
