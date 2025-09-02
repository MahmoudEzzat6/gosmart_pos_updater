// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_windows/webview_windows.dart';

// import '../../../helpers/navigation_helper.dart';
// import '../../../widget/loading_percent_dialog.dart';
// import 'package:pos_windows_ice_hub/services/odoo.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/views/all_pos_screens.dart';

// class AdminWebviewScreen extends StatefulWidget {
//   const AdminWebviewScreen({super.key});

//   @override
//   State<AdminWebviewScreen> createState() => _AdminWebviewScreenState();
// }

// class _AdminWebviewScreenState extends State<AdminWebviewScreen> {
//   final webViewController = WebviewController();
//   bool isWebViewInitialized = false;
//   bool showLoading = false;

//   String odooSessionId = '';

//   FutureOr<void> onGoBack(dynamic value) async {
//     await webViewController.loadUrl('http://157.180.44.40:8069/web?db=ice_cream_hub_maadi#action=107&cids=1&menu_id=70');
//   }

//   @override
//   void initState() {
//     super.initState();
//     initWebView();
//   }

//   Future<void> initWebView() async {
//     final odooSession = await Odoo().initOdooConnection();

//     if (odooSession != null) {
//       log('ODOO SESSION ID >> ${odooSession.id}');

//       odooSessionId = odooSession.id;

//       await webViewController.initialize();

//       webViewController.url.listen((url) {
//         log('URL changed: $url');
//         if (url.contains('pos.config')) {
//           Navigation().goToScreenWithGoBack(context, (context) => const AllPosScreens(), onGoBack);
//         }
//       });

//       webViewController.loadingState.listen((state) async {
//         if (state == LoadingState.loading) {
//           showDialog(context: context, builder: (_) => const LoadingPercentDialog());
//           showLoading = true;
//         } else if (state == LoadingState.navigationCompleted && showLoading) {
//           // Inject session_id cookie via JavaScript
//           await webViewController.addScriptToExecuteOnDocumentCreated("""
//             document.cookie = "session_id=${odooSession.id}; domain=157.180.44.40; path=/";
//           """);

//           Navigation().closeDialog(context);
//           showLoading = false;
//         }
//       });

//       await webViewController.loadUrl('http://157.180.44.40:8069/web?db=ice_cream_hub_maadi#action=107&cids=1&menu_id=70');

//       setState(() {
//         isWebViewInitialized = true;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     webViewController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isWebViewInitialized ? Webview(webViewController) : const Center(child: CircularProgressIndicator()),
//       floatingActionButton: FloatingActionButton(onPressed: () async {
//         await webViewController.executeScript("""
//             document.cookie = "session_id=$odooSessionId; domain=157.180.44.40; path=/";
//           """);

//         await webViewController.loadUrl('http://157.180.44.40:8069/web?db=ice_cream_hub_maadi#action=107&cids=1&menu_id=70');
//       }),
//     );
//   }
// }
// //admin@gosmart.eg
// //admin@gosmart.eg
