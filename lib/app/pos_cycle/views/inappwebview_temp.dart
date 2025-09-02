// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
// import 'package:pos_windows_ice_hub/services/odoo.dart';
// import 'package:provider/provider.dart';

// import '../../../helpers/navigation_helper.dart';
// import '../../../widget/loading_percent_dialog.dart';
// import 'home_screen.dart';

// class AdminWebviewScreen extends StatefulWidget {
//   const AdminWebviewScreen({super.key});

//   @override
//   State<AdminWebviewScreen> createState() => _AdminWebviewScreenState();
// }

// class _AdminWebviewScreenState extends State<AdminWebviewScreen> {
//   bool dataLoaded = true;
//   bool showLoading = false;
//   int pageProgress = 0;

//   InAppWebViewController? webViewController;

//   InAppWebViewSettings settings = InAppWebViewSettings(
//     isInspectable: false,
//     mediaPlaybackRequiresUserGesture: false,
//     allowsInlineMediaPlayback: true,
//     iframeAllow: "camera; microphone",
//     iframeAllowFullscreen: true,
//     javaScriptEnabled: true,
//     useOnDownloadStart: true,
//   );

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() async {
//       await Odoo().initOdooConnection().then((odooSessuion) async {
//         //* //*
//         log('ODOO SESSION ID >> ${odooSessuion!.id}');

//         //* //*
//         CookieManager cookieManager = CookieManager.instance();

//         await cookieManager.setCookie(name: 'session_id', value: odooSessuion.id, url: WebUri('erp.gosmart.ae'));

//         // await WebViewCookieManager()
//         //     .setCookie(WebViewCookie(name: 'session_id', value: odooSessuion.id, domain: 'erp.gosmart.ae'));

//         dataLoaded = true;

//         setState(() {});
//       });
//     });
//   }

//   final GlobalKey webViewKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: dataLoaded
//           ? InAppWebView(
//               key: webViewKey,
//               initialSettings: settings,
//               //  onWebViewCreated: _onWebViewCreated,
//               onWebViewCreated: (controller) async {
//                 webViewController = controller;
//               },
//               //*

//               initialUrlRequest: URLRequest(
//                   url: WebUri('https://erp.gosmart.ae/web#action=595&model=pos.config&view_type=kanban&cids=1&menu_id=382')),

//               onProgressChanged: (controller, progress) {
//                 log('progress: $progress');
//                 context.read<PosProvider>().setLoadingPercentage = progress;
//               },
//               onLoadStart: (controller, url) async {
//                 log('onPageStarted $url');

//                 //  Navigation().showLoadingSpinnerDialog(context);
//                 showDialog(context: context, builder: (context) => const LoadingPercentDialog());

//                 showLoading = true;
//               },
//               onLoadStop: (controller, url) {
//                 if (showLoading) {
//                   Navigation().closeDialog(context);
//                   showLoading = false;
//                 }
//               },
//             )
//           : const Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }
