import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_hid_listener/barcode_hid_listener.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BarcodeKeyboardService Tests', () {
    test('Exclusive Handler Guard silences previous instance when new instance starts', () {
      final serviceA = BarcodeKeyboardService(const BarcodeScannerConfig());
      final serviceB = BarcodeKeyboardService(const BarcodeScannerConfig());

      serviceA.start();
      expect(serviceA.isActive, isTrue);
      expect(serviceB.isActive, isFalse);

      // Starting service B should automatically stop service A
      serviceB.start();
      expect(serviceA.isActive, isFalse);
      expect(serviceB.isActive, isTrue);

      serviceA.dispose();
      serviceB.dispose();
    });

    test('dispose() clears _activeInstance when paused', () {
      final service = BarcodeKeyboardService(const BarcodeScannerConfig())
        ..start();
      expect(service.isActive, isTrue);

      service.stop(); // Paused
      expect(service.isActive, isFalse);

      service.dispose();
      
      final serviceB = BarcodeKeyboardService(const BarcodeScannerConfig())
        ..start();
      expect(serviceB.isActive, isTrue);
      serviceB.dispose();
    });
  });

  group('BarcodeFormat Tests', () {
    test('detectFormat detects EAN-13', () {
      expect(
        BarcodeFormat.detectFormat('1234567890123', [BarcodeFormat.ean13]),
        BarcodeFormat.ean13,
      );
    });

    test('detectFormat detects UPC-E only if filtered', () {
      expect(
        BarcodeFormat.detectFormat('01234567', [BarcodeFormat.upcE]),
        BarcodeFormat.upcE,
      );
      
      expect(
        BarcodeFormat.detectFormat('01234567', BarcodeFormat.values),
        BarcodeFormat.ean8, // Since ean8 comes first
      );
    });
  });
}
