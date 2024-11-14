import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movil_educontrol/main.dart' as app; // Cambia el nombre del paquete según tu pubspec.yaml.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Prueba básica de integración', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Realiza verificaciones.
    expect(find.text('Texto que buscas'), findsOneWidget);
  });
}
