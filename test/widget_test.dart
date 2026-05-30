// This is a basic Flutter widget test.

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:stratos_academy/controllers/auth_controller.dart';
import 'package:stratos_academy/controllers/course_controller.dart';
import 'package:stratos_academy/models/enums.dart';
import 'package:stratos_academy/main.dart';

class MockAuthController extends AuthController {
  @override
  AppState get authState => AppState.unauthenticated;
}

// Mock HTTP client to handle NetworkImage requests in tests
class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => MockHttpClientRequest();
  
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #autoUncompress) return true;
    return null;
  }
}

class MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => MockHttpClientResponse();
  
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;
  
  @override
  int get contentLength => mockImage.length;
  
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  
  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([mockImage]).listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

final List<int> mockImage = [
  137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0, 0, 0, 13, 73, 68, 65, 84, 120, 94, 99, 96, 64, 5, 0, 0, 2, 0, 1, 70, 34, 4, 2, 0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130
];

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  testWidgets('App renders completely', (WidgetTester tester) async {
    // Set a large screen size to prevent layout overflows on desktop design in test env
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final authController = MockAuthController();

    // Build our app and trigger a frame with the necessary providers.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>.value(value: authController),
          ChangeNotifierProvider(create: (_) => CourseController()),
        ],
        child: const StratosAcademyApp(),
      ),
    );

    // Let the AuthController initialization complete
    await tester.pump();

    // Pump with a duration to trigger the Future.delayed in SplashScreen navigation
    await tester.pump(const Duration(seconds: 3));
    
    // Pump individual frames to let the routing transaction complete
    // We avoid pumpAndSettle because SplashScreen contains an infinite repeating animation
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  });
}
