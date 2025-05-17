import 'package:flutter/material.dart';
import 'package:flutter_webkul_alert_box/flutter_webkul_alert_box.dart';

void alertBox(
  BuildContext context,
  String title,
  Widget widget,
  List<Widget> actions,
) {
  mobikulAlertBox(context, title: title, icon: widget, actions: actions);
}
