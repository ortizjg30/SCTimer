import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

mixin HooksMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) => buildWithHooks(context),
    );
  }

  Widget buildWithHooks(BuildContext context);
}
