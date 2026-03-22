import 'package:flutter_test/flutter_test.dart';

import 'package:webapp/main.dart';

void main() {
  testWidgets('Погода отображается на стартовом экране', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('Москва'), findsOneWidget);
    expect(find.text('-24°'), findsWidgets);
  });
}
