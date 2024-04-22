import 'package:flutter/material.dart';
import 'package:ttc_app/theme.dart';

class ContentBox extends StatelessWidget {
  const ContentBox({
    super.key,
    required this.children,
    required this.title,
  });

  final List<Widget> children;
  final List<Widget> title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: CustomScrollView(primary: true, slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
          SliverAppBar(
            leading: null,
            automaticallyImplyLeading: false,
            pinned: true,
            toolbarHeight: 90,
            title: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                ...title
              ],
            ),
            centerTitle: false,
            surfaceTintColor: bgColor,
            backgroundColor: bgColor,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(
                color: primaryColor,
                endIndent: 15,
                indent: 15,
                height: 1,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
