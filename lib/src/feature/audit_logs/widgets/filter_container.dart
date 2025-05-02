import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/src/core/index.dart';

class FilterContainer extends ConsumerStatefulWidget {
  final List<String> titles;
  final List<Widget> widgets;

  const FilterContainer({
    super.key,
    required this.titles,
    required this.widgets,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterContainerState();
}

class _FilterContainerState extends ConsumerState<FilterContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.titles.length, (index) {
        return Row(
          spacing: Sizes.p12,
          children: [
            Text(widget.titles[index]),
            SizedBox(width: 330, child: widget.widgets[index]),
          ],
        );
      }),
    );
  }
}
