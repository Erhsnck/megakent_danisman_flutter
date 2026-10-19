import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megakent_danisman/main.dart';

void main() {
  testWidgets('App loads and shows MegakentApp', (WidgetTester tester) async {
    await tester.pumpWidget(const MegakentApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
