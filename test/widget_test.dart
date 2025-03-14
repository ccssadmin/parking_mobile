import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:par/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create a ValueNotifier<GraphQLClient> instance.
    final client = ValueNotifier(
      GraphQLClient(
        link: HttpLink('https://parkkingzapi.crestclimbers.com/graphql/'),
        cache: GraphQLCache(),
      ),
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(client: client));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
