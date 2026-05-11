// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stratos_academy/main.dart';

void main() {
  testWidgets('App renders completely', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StratosAcademyApp());
  });
}
