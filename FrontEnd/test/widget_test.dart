import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartpark/main.dart';
import 'package:smartpark/views/login.dart';
import 'package:smartpark/views/signup.dart';
import 'package:smartpark/views/welcome_screen.dart';

void main() {
  testWidgets('Welcome screen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that WelcomeScreen shows "Welcome".
    expect(find.text('Welcome'), findsOneWidget);

    // Verify that the Login and Sign up buttons are present.
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });

  testWidgets('Navigates to Login screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Tap the Login button and trigger a frame.
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(); // Wait for navigation animation to complete

    // Verify that we are on the Login screen.
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('Navigates to Sign up screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Tap the Sign up button and trigger a frame.
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle(); // Wait for navigation animation to complete

    // Verify that we are on the Sign up screen.
    expect(find.byType(SignupPage), findsOneWidget);
  });
}
