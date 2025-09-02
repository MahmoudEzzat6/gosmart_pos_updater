import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pos_windows_ice_hub/app/auth_cycle/model/login_model.dart';
import 'package:pos_windows_ice_hub/app/auth_cycle/services/auth_apis.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/views/pos_setting.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/settings/resize_screen.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/views/admin_inappwebview_screen.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/views/home_screen.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/localized_helper.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/main.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/ok_dialog.dart';
import 'package:provider/provider.dart';
import '../../pos_cycle/views/admin_webview_screen.dart';

// https://drive.google.com/file/d/1QPAVaz_cUKqq_TIVL3ORtZhS3VGpqMge/view?usp=sharing
// https://drive.google.com/uc?export=download&id=1QPAVaz_cUKqq_TIVL3ORtZhS3VGpqMge

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  String deviceId = '';

  String appVersion = '';
  String buildNumber = '';

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  initState() {
    super.initState();
    Future.microtask(() async {
      // deviceId = (await PlatformDeviceId.getDeviceId)!.toLowerCase().trim();

      final deviceInfodata = await deviceInfo.deviceInfo;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final allInfo = deviceInfodata.data;

      allInfo.forEach((key, value) {
        log('$key: $value');
      });

      appVersion = packageInfo.version;
      buildNumber = packageInfo.buildNumber;

      print(
          'AppVersion: $appVersion -- BuildNumber: ${packageInfo.buildNumber}');

      await PosApis().addClientUniqueID(deviceId);

      print('DEVICE UUID >> $deviceId');

      setState(() {});
    });
  }

  //* MARIAM
  // @override
  // void initState() {
  //   super.initState();
  //   Future.microtask(() async {
  //     await context.read<PosProvider>().isOnline();

  //     if (mounted) {
  //       bool internetconnect = context.read<PosProvider>().connectState;

  //       print("internet connection is ${internetconnect}");
  //       if (!internetconnect) {
  //         showDialog(
  //             context: context,
  //             builder: (context) => OkDialog(
  //                   text:'please_check_internet_connection'.tr(),
  //                   onPressed: () {
  //                     Navigation().closeDialog(context);
  //                   },
  //                 ));
  //       }
  //     }
  //   });
  // }

  bool isHidden = true;

  final emailController = TextEditingController(text: 'cashier1@pos.app');
  final passwordController = TextEditingController(text: '123');

  // final emailController = TextEditingController(text: 'cashier_acc@icehub.gosmart');
  // final passwordController = TextEditingController(text: '123');

  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<String> texts = [
    "Manage Sales, Inventory & Other Transactions",
    "Track Expenses and Generate Reports Easily",
    "Enhance Productivity with Smart Features",
  ];

  final List<String> textsAr = [
    "إدارة المبيعات والمخزون وغيرها من المعاملات",
    "تتبع النفقات وإنشاء التقارير بسهولة",
    "تعزيز الإنتاجية باستخدام الميزات الذكية",
  ];

  // bool userTypeChosen = false;
  // bool isAdmin = false;

  // //* DEMO
  // @override
  // void initState() {
  //   super.initState();
  //   Future.microtask(() async {
  //     //*
  //     print(MediaQuery.sizeOf(context).height);
  //     print(MediaQuery.sizeOf(context).width);
  //     //*
  //     Navigation().showLoadingGifDialog(context);
  //     //*
  //     await context.read<PosProvider>().login('cashier1@pos.app', '123').then((value) {
  //       //   await context.read<PosProvider>().login('admin@gosmart.eg', 'admin@gosmart.eg').then((value) {
  //       //*
  //       Login loginResponse = context.read<PosProvider>().loginData;
  //       //*
  //       Navigation().closeDialog(context);
  //       //*
  //       if (loginResponse.status == 1) {
  //         //* ALL GOOD

  //         if (loginResponse.role!.toLowerCase() == 'admin') {
  //           //* IS ADMIN
  //           Navigation().goToScreen(context, (context) => const AdminWebviewScreen());
  //         } else {
  //           //* CASHIER
  //           Navigation().goToScreen(context, (context) => HomeScreen(isAdmin: false));
  //         }
  //       } else {
  //         showDialog(context: context, builder: (context) => OkDialog(text: loginResponse.messageAr!));
  //       }
  //     });
  //   });
  // }

  //* //* //* //*
  //* //* //* //*
  // DisplayManager displayManager = DisplayManager();
  // List<Display?> displays = [];

  // @override
  // void initState() {
  //   displayManager.connectedDisplaysChangedStream?.listen(
  //     (event) {
  //       debugPrint("connected displays changed: $event");
  //     },
  //   );
  //   super.initState();
  // }

  //* //* //*

  Future<void> login() async {
    Navigation().showLoadingGifDialog(context);
    //*
    // deviceId = (await PlatformDeviceId.getDeviceId)!.toLowerCase().trim();

    await PosApis().addClientUniqueID(deviceId);

    await AuthApis()
        .login(emailController.text, passwordController.text, deviceId, context)
        .then((loginData) async {
      if (loginData == null) {
        await login();
      } else {
        context.read<PosProvider>().setLoginData = loginData;
        //  Navigation().closeDialog(context);
        if (loginData.status == 1) {
          //* ALL GOOD

          if (loginData.role!.toLowerCase() == 'admin') {
            //* IS ADMIN
            context.read<PosProvider>().setAdminId = loginData.userId!;
            Navigation().goToScreen(
              context,
              (context) => AdminWebviewScreen(
                  email: emailController.text,
                  password: passwordController.text),
            );
          } else {
            //* CASHIER
            Navigation()
                .goToScreen(context, (context) => HomeScreen(isAdmin: false));
          }
        } else {
          showDialog(
            context: context,
            builder: (context) => OkDialog(
              text: context.localizedValue(
                  en: loginData.message!, ar: loginData.messageAr!),
              onPressed: () {
                Navigation().closeDialog(context);
              },
            ),
          );
        }
      }
    });
    //*
    // await context.read<PosProvider>().login(emailController.text, passwordController.text, deviceId).then((value) {
    //   //*
    //   Login loginResponse = context.read<PosProvider>().loginData;
    //   //*
    //   Navigation().closeDialog(context);
    //   //*
    //   if (loginResponse.status == 1) {
    //     //* ALL GOOD

    //     if (loginResponse.role!.toLowerCase() == 'admin') {
    //       //* IS ADMIN
    //       Navigation().goToScreen(context, (context) => const AdminWebviewScreen());
    //     } else {
    //       //* CASHIER
    //       Navigation().goToScreen(context, (context) => HomeScreen(isAdmin: false));
    //     }
    //   } else {
    //     showDialog(
    //         context: context,
    //         builder: (context) => OkDialog(
    //               text: context.localizedValue(
    //                 en: loginResponse.message!,
    //                 ar: loginResponse.messageAr!,
    //               ),
    //               onPressed: () {
    //                 Navigation().closeDialog(context);
    //               },
    //             ));
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);

    // print(MediaQuery.sizeOf(context).height);
    // print(MediaQuery.sizeOf(context).width);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: AppDimentions().availableheightWithAppBar,
        width: AppDimentions().availableWidth,
        child: Row(
          children: [
            // Left Side - Scrolling Illustrations & Text
            GestureDetector(
              onTap: () {
                Navigation()
                    .goToScreen(context, (context) => const ResizeScreen());
              },
              child: Container(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.settings, color: Colors.grey[600])),
            ),

            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // PageView for illustrations and text
                    SizedBox(
                      height: 350.h,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: texts.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              final isLastPage = index == texts.length - 1;
                              if (isLastPage) {
                                _pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linear,
                                );
                              } else {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.linear);
                              }

                              // emailController.text = 'cashier_acc@pos.app';
                              // passwordController.text = '123';
                            },
                            // onDoubleTap: () {
                            //   emailController.text = 'admin@icehub.com';
                            //   passwordController.text = 'admin@icehub.com';
                            // },
                            child: Column(
                              children: [
                                Image.asset('assets/images/illustration.png',
                                    height: 250.h),
                                SizedBox(height: 20.h),
                                Text(
                                  context.locale == const Locale('ar')
                                      ? textsAr[index]
                                      : texts[index],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: black),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Dots Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        texts.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: 8,
                          width: _currentPage == index ? 30 : 10,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? goSmartBlue
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                    Center(
                        child: Text(deviceId,
                            textAlign: TextAlign.center, style: boldText)),
                  ],
                ),
              ),
            ),

            // Right Side - Login Form
            Expanded(
              flex: 5,
              child: Container(
                height: AppDimentions().availableheightWithAppBar,
                width: AppDimentions().availableWidth,
                decoration: const BoxDecoration(color: lightOrange),
                child: Center(
                  child: SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 50.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset('assets/images/gg.png',
                                    width: 80, height: 80),
                              ),
                              SizedBox(height: 10.h),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       'GoSmart ',
                              //       style: mediumText,
                              //     ),
                              //     Text(
                              //       'POS',
                              //       style: mediumText.copyWith(color: goSmartBlue),
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SizedBox(
                                height:
                                    AppDimentions().availableheightWithAppBar *
                                        .65,
                                width: AppDimentions().availableWidth * .3,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(color: goSmartBlue),
                                  ),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "sign_in".tr(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: goSmartBlue,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          // Email Field
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'email'.tr(),
                                                style: const TextStyle(
                                                    color: black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                controller: emailController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: white,
                                                  contentPadding:
                                                      const EdgeInsets.all(15),
                                                  isDense: true,
                                                  //*
                                                  border:
                                                      loginRegisterTextBorder,
                                                  errorBorder:
                                                      loginRegisterTextBorder,
                                                  enabledBorder:
                                                      loginRegisterTextBorder,
                                                  focusedBorder:
                                                      loginRegisterTextBorder,
                                                  //*
                                                  hintText: 'email'.tr(),
                                                  prefixIconConstraints:
                                                      const BoxConstraints(
                                                          minWidth: 0,
                                                          minHeight: 0),
                                                ),
                                                validator: (email) {
                                                  if (email == null ||
                                                      email.isEmpty) {
                                                    return 'valid_value'.tr();
                                                  }

                                                  // Regular expression for validating email
                                                  // final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                                  // if (!regex.hasMatch(email)) {
                                                  //   return 'Please enter a valid email address';
                                                  // }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 15),
                                          // Password Field
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'password'.tr(),
                                                style: const TextStyle(
                                                    color: black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                controller: passwordController,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: white,
                                                  contentPadding:
                                                      const EdgeInsets.all(15),
                                                  isDense: true,
                                                  border:
                                                      loginRegisterTextBorder,
                                                  errorBorder:
                                                      loginRegisterTextBorder,
                                                  enabledBorder:
                                                      loginRegisterTextBorder,
                                                  focusedBorder:
                                                      loginRegisterTextBorder,
                                                  hintText: 'password'.tr(),
                                                  prefixIconConstraints:
                                                      const BoxConstraints(
                                                          minWidth: 0,
                                                          minHeight: 0),
                                                  suffixIcon: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isHidden = !isHidden;
                                                      });
                                                    },
                                                    child: Icon(isHidden
                                                        ? Icons
                                                            .remove_red_eye_outlined
                                                        : Icons.remove_red_eye),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return 'valid_value'.tr();
                                                  }
                                                  return null;
                                                },
                                                obscureText: isHidden,
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          //   const SizedBox(height: 10),
                                          // Login Button
                                          SizedBox(
                                            height: 50.h,
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (await hasInternet(
                                                    context)) {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    login();
                                                  }
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        OkDialog(
                                                      text:
                                                          'please_check_internet_connection'
                                                              .tr(),
                                                      onPressed: () {
                                                        Navigation()
                                                            .closeDialog(
                                                                context);
                                                      },
                                                    ),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: goSmartBlue,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                              child: Text(
                                                "login".tr(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                              'NOT UPDATED >> $appVersion -- $buildNumber'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
