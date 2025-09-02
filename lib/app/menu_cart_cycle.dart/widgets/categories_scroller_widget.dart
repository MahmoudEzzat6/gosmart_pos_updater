import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:provider/provider.dart';

class CategoriesScrollerWidget extends StatefulWidget {
  const CategoriesScrollerWidget({super.key});

  @override
  State<CategoriesScrollerWidget> createState() => _CategoriesScrollerWidgetState();
}

class _CategoriesScrollerWidgetState extends State<CategoriesScrollerWidget> {
  late final ScrollController _scrollController;

  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuProviderWatch = context.watch<MenuProvider>();
    final menuProviderRead = context.read<MenuProvider>();

    final categories = menuProviderWatch.categories.data!;

    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          final newOffset = _scrollController.offset + pointerSignal.scrollDelta.dy;
          final maxScroll = _scrollController.position.maxScrollExtent;
          final minScroll = _scrollController.position.minScrollExtent;

          _scrollController.jumpTo(
            newOffset.clamp(minScroll, maxScroll),
          );
        }
      },
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategoryIndex == index;

            return GestureDetector(
              onTap: () {
                print('Chosen Category: ${category.nameAr} -- ${category.id}');
                menuProviderRead.getCategoryProducts(category.id!);
                setState(() => selectedCategoryIndex = index);
              },
              child: Container(
                width: 180.w,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isSelected ? goSmartBlue : Colors.grey[50]!,
                      isSelected ? goSmartBlue.withOpacity(0.5) : Colors.grey[50]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey[300]!, blurRadius: 2, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          category.image!,
                          height: 50.h,
                          width: 50.w,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.error),
                          loadingBuilder: (_, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 50.h,
                              width: 50.w,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: goSmartBlue,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          textDirection: context.locale == const Locale('ar') ? TextDirection.rtl : TextDirection.ltr,
                          context.locale == const Locale('ar')
                              ? category.nameAr!.isEmpty
                                  ? category.name!
                                  : category.nameAr!
                              : category.name!,
                          //maxLines: 2,
                          style: boldText.copyWith(
                            fontSize: 17.sp,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          //overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
