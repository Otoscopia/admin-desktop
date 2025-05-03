import 'package:fluent_ui/fluent_ui.dart';

class PageContainer extends ScaffoldPage {
  final Widget _content;

  @override
  Widget get content => _content;

  const PageContainer({
    super.key,
    super.header,
    super.bottomBar,
    super.padding = EdgeInsets.zero,
    super.resizeToAvoidBottomInset = true,
    Widget content = const SizedBox.expand(),
  }) : _content = content;

  PageContainer.scrollable({
    super.key,
    super.header,
    super.bottomBar,
    super.padding,
    super.resizeToAvoidBottomInset,
    ScrollController? scrollController,
    required List<Widget> children,
  }) : _content = ScaffoldPage.scrollable(
          key: key,
          bottomBar: bottomBar,
          header: header,
          padding: padding,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          scrollController: scrollController,
          children: children,
        );

  PageContainer.withPadding({
    super.key,
    super.header,
    super.bottomBar,
    super.padding = const EdgeInsets.all(16),
    required Widget content,
    super.resizeToAvoidBottomInset = true,
  }) : _content = ScaffoldPage.withPadding(
          key: key,
          bottomBar: bottomBar,
          header: header,
          padding: padding,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          content: content,
        );
}
