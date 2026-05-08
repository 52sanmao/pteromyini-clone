import 'package:flutter_test/flutter_test.dart';
import 'package:pteromyini_clone/app.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const PteromyiniApp());
    await tester.pumpAndSettle();
  });
}
