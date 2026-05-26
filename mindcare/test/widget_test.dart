import 'package:flutter_test/flutter_test.dart';

import 'package:mindcare/main.dart';
import 'package:mindcare/screens/login_screen.dart';

void main() {
  testWidgets('app opens on login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MindCareApp());

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('MindCare'), findsOneWidget);
  });
}
