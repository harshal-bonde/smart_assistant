import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/suggestions/presentation/widgets/suggestion_card.dart';
import 'package:smart_assistant/suggestions/domain/data_class/suggestion.dart';

void main() {
  group('SuggestionCard Widget', () {
    testWidgets('displays title and description', (tester) async {
      const suggestion = Suggestion(
        id: 1,
        title: 'Test Suggestion',
        description: 'Test Description',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SuggestionCard(
              suggestion: suggestion,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Suggestion'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      const suggestion = Suggestion(
        id: 1,
        title: 'Tap Test',
        description: 'Tap Description',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SuggestionCard(
              suggestion: suggestion,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Test'));
      expect(tapped, isTrue);
    });

    testWidgets('shows arrow icon', (tester) async {
      const suggestion = Suggestion(
        id: 1,
        title: 'Icon Test',
        description: 'Icon Description',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SuggestionCard(
              suggestion: suggestion,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
    });
  });
}
