import 'dart:async';
import 'dart:io';
import 'package:auto_updater/auto_updater.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pos_windows_ice_hub/app/auth_cycle/views/login_screen.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/provider/open_cheque_provider.dart';
import 'package:pos_windows_ice_hub/app/second_screen_cycle/views/second_screen_cart.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/ok_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'app/pos_cycle/providers/pos_provider.dart';
import 'styles/colors.dart';
import 'package:path_provider/path_provider.dart';

import 'package:easy_localization/easy_localization.dart' as loc;

int posId = 21;
int currencyId = 74;

final navigatorKey = GlobalKey<NavigatorState>();

Future<bool> hasInternet(BuildContext context) async {
  Navigation().showLoadingGifDialog(context);
  bool hasConnection = await InternetConnectionChecker.instance.hasConnection;
  Navigation().closeDialog(context);
  print(hasConnection);
  return hasConnection;
}

List<Size> commonScreenSizes = [
  // SVGA / XGA (old small screens)
  const Size(800, 600), // SVGA
  const Size(1024, 768), // XGA (very common legacy)
  const Size(1152, 864), // XGA+

  // WXGA & small widescreens
  const Size(1280, 720), // 720p HD
  const Size(1280, 800), // WXGA (MacBooks, small laptops)
  const Size(1366, 768), // most popular laptop size

  // HD+ / WSXGA
  const Size(1440, 900), // WXGA+ (MacBook Air, common widescreen)
  const Size(1600, 900), // HD+
  const Size(1680, 1050), // WSXGA+

  // Full HD (1080p)
  const Size(1920, 1080), // FHD

  // QHD / WQHD
  // const Size(2048, 1152), // QHD-lite
  // const Size(2560, 1440), // QHD / 1440p

  // WQHD+ / UW (optional ultrawide, can include if needed)
  // Size(2560, 1600), // WQXGA (MacBook Pro 16", optional)
  // Size(3440, 1440), // ultrawide, optional

  // 4K UHD
  // const Size(3840, 2160), // 4K UHD
];
Future<void> enableResizeMode() async {
  await windowManager.ensureInitialized();

  // Allow resize
  await windowManager.setResizable(true);

  // Allow maximize button
  await windowManager.setMaximizable(true);

  // Allow any maximum size
  await windowManager
      .setMaximumSize(const Size(double.infinity, double.infinity));

  // Set a reasonable minimum
  await windowManager.setMinimumSize(
      Size(commonScreenSizes.first.width, commonScreenSizes.first.height));
}

StreamSubscription? _listener;
bool _isDialogShowing = false;

void startListeningToInternet() {
  _listener =
      InternetConnectionChecker.instance.onStatusChange.listen((status) {
    final hasConnection = status == InternetConnectionStatus.connected;
    final context = navigatorKey.currentState?.overlay?.context;

    if (!hasConnection && !_isDialogShowing && context != null) {
      _isDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          // title: Text("no_internet".tr() , style: mediumText,textAlign: TextAlign.start,),
          content: SizedBox(
              width: 400.w,
              child: Text(
                'please_check_internet_connection'.tr(),
                style: smallText,
                textAlign: TextAlign.center,
              )),
        ),
      );
    } else if (hasConnection && _isDialogShowing && context != null) {
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss dialog
      _isDialogShowing = false;
    }
  });
}

// void startListeningToInternet() {
//   _listener = InternetConnectionChecker.instance.onStatusChange.listen((status) {
//     final hasConnection = status == InternetConnectionStatus.connected;
//     final context = navigatorKey.currentState?.overlay?.context;

//     if (!hasConnection && !_isDialogShowing && context != null) {
//       _isDialogShowing = true;
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => AlertDialog(
//           // title: Text("no_internet".tr() , style: mediumText,textAlign: TextAlign.start,),
//           content: SizedBox(
//               width: 400.w,
//               child: Text(
//                 'please_check_internet_connection'.tr(),
//                 style: smallText,
//                 textAlign: TextAlign.center,
//               )),
//         ),
//       );
//     } else if (hasConnection && _isDialogShowing && context != null) {
//       Navigator.of(context, rootNavigator: true).pop(); // Dismiss dialog
//       _isDialogShowing = false;
//     }
//   });
// }

// Route<dynamic> generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case '/':
//       return MaterialPageRoute(builder: (_) => const LoginScreen());
//     case 'cart':
//       return MaterialPageRoute(builder: (_) => const SecondScreenCart());
//     default:
//       return MaterialPageRoute(
//           builder: (_) => Scaffold(
//                 body: Center(child: Text('No route defined for ${settings.name}')),
//               ));
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //* AUTO UPDATE
  //*
  //Replace with the DIRECT URL to your appcast.xml on Google Drive (see Step 7)

  //final autoUpdater = AutoUpdater();
  const feedURL =
      'https://drive.google.com/uc?export=download&id=YOUR_APPCAST_FILE_ID';

  await autoUpdater.setFeedURL(feedURL);
  await autoUpdater.checkForUpdates(); // checks once on startup
  await autoUpdater.setScheduledCheckInterval(3600); // hourly; 0 disables
  //*
  //*
  await windowManager.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  final pref = await SharedPreferences.getInstance();

  final screenWidth = pref.getDouble('screenWidth') ?? 800;
  final screenHeight = pref.getDouble('screenHeight') ?? 600;

  var size = Size(screenWidth, screenHeight);

  WindowOptions options = WindowOptions(
    size: size,
    center: true,
    titleBarStyle: TitleBarStyle.normal, // keep native buttons
  );

  await windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.setResizable(true);
    await windowManager.setMaximizable(true);

    await windowManager.setSize(size);
    await windowManager.center();

    await windowManager.show();
    await windowManager.focus();
    await windowManager.setPreventClose(true);
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  //* ENABLE ACCEPT CERTIFICATES
  HttpOverrides.global = MyHttpOverrides();

  await loc.EasyLocalization.ensureInitialized();

  startListeningToInternet();

  runApp(loc.EasyLocalization(
    supportedLocales: const [
      Locale('en', ''), // English
      Locale('ar', ''), // Arabic
    ],
    path: 'assets/translations', // Path to your translation files
    fallbackLocale: const Locale('en', ''),
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PosProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => OpenChequeProvider()),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    enableResizeMode();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Future<void> onWindowClose() async {
    // If preventClose is on, we decide what happens.
    if (await windowManager.isPreventClose()) {
      final ctx = navigatorKey.currentContext!;
      final shouldExit = await showDialog<bool>(
        context: ctx,
        builder: (context) => AlertDialog(
          content: Text('are_you_sure_close'.tr()),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('cancel'.tr()),
                )),
            FilledButton(
                //  onPressed: () => Navigator.pop(context, true),
                onPressed: () {
                  exit(0);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('exit'.tr()),
                )),
          ],
        ),
      );

      if (shouldExit == true) {
        // Allow close and destroy the window
        await windowManager.setPreventClose(false);
        await windowManager.destroy();
      }
      // If user canceled, do nothing (window stays open).
    }
  }

  @override
  Widget build(BuildContext context) {
    context.setLocale(const Locale('ar'));
    return ScreenUtilInit(
      designSize: const Size(1366, 768), //* TABLET

      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          //*
          //    onGenerateRoute: generateRoute,
          initialRoute: '/',
          //*
          builder: (context, widget) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                //*
                await context.read<PosProvider>().isOnline();

                bool internetconnect = context.read<PosProvider>().connectState;

                print("internet connection is $internetconnect");
                if (!internetconnect) {
                  showDialog(
                      context: context,
                      builder: (context) => OkDialog(
                            text: 'please_check_internet_connection'.tr(),
                            onPressed: () {
                              Navigation().closeDialog(context);
                            },
                          ));
                }

                //*
              },
              child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: widget!)),
            );
          },
          theme: ThemeData(
            useMaterial3: false,
            fontFamily: context.locale == const Locale('ar') ? 'Tajawal' : null,
            colorScheme: ColorScheme.fromSeed(
                seedColor: goSmartBlue,
                primary: goSmartBlue,
                secondary: goSmartBlue),
            appBarTheme: const AppBarTheme(
              //  actionsIconTheme: const IconThemeData(color: mainPurble),
              iconTheme: IconThemeData(color: black),
              centerTitle: true,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 1,
              //    titleTextStyle: GoogleFonts.dmSans(fontSize: 20.sp, color: darkBlue, fontWeight: FontWeight.w700),
            ),
          ),
          home: child,
        );
      },

      //    child: const HomeScreen(isAdmin: false),
      child: const LoginScreen(),
      //   child: const AllPosScreens(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//*
//* SECOND SCREEN

// @pragma('vm:entry-point')
// Future<void> secondaryDisplayMain() async {
//   debugPrint('second main');

//   WidgetsFlutterBinding.ensureInitialized();

//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.landscapeLeft,
//     DeviceOrientation.landscapeRight,
//   ]);

//   await loc.EasyLocalization.ensureInitialized();

//   runApp(loc.EasyLocalization(
//     supportedLocales: const [
//       Locale('en', ''), // English
//       Locale('ar', ''), // Arabic
//     ],
//     path: 'assets/translations', // Path to your translation files
//     fallbackLocale: const Locale('en', ''),
//     child: const MySecondApp(),
//   ));

//   // runApp(const MySecondApp());
// }

// class MySecondApp extends StatelessWidget {
//   const MySecondApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     context.setLocale(const Locale('ar'));
//     return ScreenUtilInit(
//       designSize: const Size(1280, 740), //* TABLET

//       minTextAdapt: true,
//       builder: (context, child) {
//         return MaterialApp(
//           supportedLocales: context.supportedLocales,
//           localizationsDelegates: context.localizationDelegates,
//           locale: context.locale,
//           debugShowCheckedModeBanner: false,
//           //*
//           onGenerateRoute: generateRoute,
//           initialRoute: 'cart',
//           //*
//           builder: (context, widget) {
//             return Directionality(
//                 textDirection: TextDirection.ltr,
//                 child:
//                     MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)), child: widget!));
//           },
//           theme: ThemeData(
//             useMaterial3: false,
//             appBarTheme: const AppBarTheme(
//               //  actionsIconTheme: const IconThemeData(color: mainPurble),
//               iconTheme: IconThemeData(color: black),
//               centerTitle: true,
//               backgroundColor: Colors.white,
//               surfaceTintColor: Colors.white,
//               elevation: 1,
//               //    titleTextStyle: GoogleFonts.dmSans(fontSize: 20.sp, color: darkBlue, fontWeight: FontWeight.w700),
//             ),
//           ),
//           home: child,
//         );
//       },

//       //    child: const HomeScreen(isAdmin: false),
//       child: const SecondScreenCart(),
//       //   child: const AllPosScreens(),
//     );
//   }
// }
