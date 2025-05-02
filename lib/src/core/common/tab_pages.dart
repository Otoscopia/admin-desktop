import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabPages extends ConsumerStatefulWidget {
  const TabPages({
    super.key,
    required this.tabTitles,
    required this.icons,
    required this.bodies,
  });

  final List<String> tabTitles;
  final List<IconData> icons;
  final List<Widget> bodies;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabPagesState();
}

class _TabPagesState extends ConsumerState<TabPages> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final content = TabView(
      currentIndex: currentIndex,
      onChanged: (value) => setState(() => currentIndex = value),
      tabs: List.generate(widget.tabTitles.length, (index) {
        return Tab(
          icon: Icon(widget.icons[index]),
          text: Text(widget.tabTitles[index]),
          body: widget.bodies[index],
        );
      }),
    );

    return ScaffoldPage(padding: EdgeInsets.zero, content: content);
  }
}
