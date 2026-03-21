import 'package:flutter/material.dart';

class MySearchbar extends StatefulWidget {
  const MySearchbar({super.key});

  @override
  State<MySearchbar> createState() => _MySearchbar();
}

class _MySearchbar extends State<MySearchbar> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext constext, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder:
          (BuildContext context, SearchController controller) {},
    );
  }
}
