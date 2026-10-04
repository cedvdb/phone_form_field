import 'package:material_ui/material_ui.dart';
import 'package:phone_form_field/country_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:phone_form_field/src/country_selector/widgets/country_list_view.dart';
import 'package:phone_form_field/src/country_selector/widgets/search_box.dart';

void main() {
  group('CountrySelectorNavigator', () {
    Widget getApp(Function(BuildContext ctx) cb) => MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => cb(ctx),
                child: const Text('press'),
              ),
            ),
          ),
        );

    testWidgets('should navigate to page', (tester) async {
      const nav = CountrySelectorNavigator.page();
      await tester.pumpWidget(getApp((ctx) => nav.show(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(CountrySelectorPage), findsOneWidget);
    });

    testWidgets('should navigate to dialog', (tester) async {
      const nav = CountrySelectorNavigator.dialog();
      await tester.pumpWidget(getApp((ctx) => nav.show(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(CountrySelectorSheet), findsOneWidget);
    });

    testWidgets('should navigate to modal bottom sheet', (tester) async {
      const nav = CountrySelectorNavigator.modalBottomSheet();
      await tester.pumpWidget(getApp((ctx) => nav.show(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CountrySelectorSheet), findsOneWidget);
    });

    testWidgets('should navigate to bottom sheet', (tester) async {
      const nav = CountrySelectorNavigator.bottomSheet();
      await tester.pumpWidget(getApp((ctx) => nav.show(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CountrySelectorSheet), findsOneWidget);
    });

    testWidgets('should navigate to draggable sheet', (tester) async {
      const nav = CountrySelectorNavigator.draggableBottomSheet();
      await tester.pumpWidget(getApp((ctx) => nav.show(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CountrySelectorSheet), findsOneWidget);
    });

    group('parameters', () {
      const showDialCodeNavigators = <CountrySelectorNavigator>[
        CountrySelectorNavigator.page(),
        CountrySelectorNavigator.dialog(),
        CountrySelectorNavigator.bottomSheet(),
        CountrySelectorNavigator.modalBottomSheet(),
        CountrySelectorNavigator.draggableBottomSheet(),
      ];

      test('should show the dial code by default', () {
        for (final navigator in showDialCodeNavigators) {
          expect(navigator.showDialCode, isTrue);
        }
      });

      test('should honour showDialCode', () {
        const navigators = <CountrySelectorNavigator>[
          CountrySelectorNavigator.page(showDialCode: false),
          CountrySelectorNavigator.dialog(showDialCode: false),
          CountrySelectorNavigator.bottomSheet(showDialCode: false),
          CountrySelectorNavigator.modalBottomSheet(showDialCode: false),
          CountrySelectorNavigator.draggableBottomSheet(showDialCode: false),
        ];
        for (final navigator in navigators) {
          expect(navigator.showDialCode, isFalse);
        }
      });

      test('should honour useRootNavigator', () {
        expect(
          const CountrySelectorNavigator.draggableBottomSheet(
            useRootNavigator: false,
          ).useRootNavigator,
          isFalse,
        );
      });
    });

    testWidgets('dialog should display the dial code', (tester) async {
      const nav = CountrySelectorNavigator.dialog();
      await tester.pumpWidget(getApp((ctx) => nav.show(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final tiles = tester.widgetList<ListTile>(find.byType(ListTile));
      expect(tiles, isNotEmpty);
      expect(
        tiles.every((tile) => tile.subtitle != null),
        isTrue,
        reason: 'the dial code of each country should be displayed',
      );
    });

    testWidgets('dialog should hide the dial code when disabled',
        (tester) async {
      const nav = CountrySelectorNavigator.dialog(showDialCode: false);
      await tester.pumpWidget(getApp((ctx) => nav.show(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final tiles = tester.widgetList<ListTile>(find.byType(ListTile));
      expect(tiles, isNotEmpty);
      expect(
        tiles.every((tile) => tile.subtitle == null),
        isTrue,
        reason: 'showDialCode: false should hide the dial codes',
      );
    });

    testWidgets('page should honour the search box parameters', (tester) async {
      const nav = CountrySelectorNavigator.page(
        searchBoxDecoration: InputDecoration(hintText: 'find a country'),
        searchBoxTextStyle: TextStyle(fontSize: 13),
        scrollPhysics: ClampingScrollPhysics(),
      );
      await tester.pumpWidget(getApp((ctx) => nav.show(ctx)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final searchBox = tester.widget<SearchBox>(find.byType(SearchBox));
      expect(searchBox.decoration?.hintText, 'find a country');
      expect(searchBox.style?.fontSize, 13);
      expect(
        tester
            .widget<CountryListView>(find.byType(CountryListView))
            .scrollPhysics,
        isA<ClampingScrollPhysics>(),
      );
    });
  });
}
