import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

void alertBox(
  BuildContext context,
  QuickAlertType type,
  void Function() confirmFun,
  void Function() cancelFun,
  String title,
) {
  QuickAlert.show(
    context: context,
    title: title,
    type: type,
    showCancelBtn: true,
    onConfirmBtnTap: confirmFun,
    onCancelBtnTap: cancelFun,
    animType: QuickAlertAnimType.slideInUp,
  );
}
