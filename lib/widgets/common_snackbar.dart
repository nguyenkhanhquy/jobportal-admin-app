import 'package:flutter/material.dart';
import 'dart:convert';

void showCustomSnackbar(BuildContext context, String message, Color color) {
  String messagee = utf8.decode(message.runes.toList());
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(messagee),
    backgroundColor: color,
  ));
}
