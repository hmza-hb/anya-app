import 'package:anya_app/anya/anya_home_page.dart';
import 'package:anya_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Anya app renders the face', (WidgetTester tester) async {
    await tester.pumpWidget(const AnyaApp());
    await tester.pump();

    expect(find.byType(AnyaHomePage), findsOneWidget);
  });
}
