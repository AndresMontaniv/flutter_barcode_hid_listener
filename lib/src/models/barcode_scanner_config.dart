import 'package:flutter/services.dart';
import 'barcode_format.dart';

class BarcodeScannerConfig {
  final List<LogicalKeyboardKey> terminators;
  final Duration bufferTimeout;
  final Duration deduplicationWindow;
  final List<BarcodeFormat> allowedFormats;
  final bool enableDebugLogs;

  /// Maximum number of characters the keystroke buffer will hold before
  /// being cleared as a safety guard against malfunctioning scanners.
  ///
  /// Must be between 10 and 256 characters.
  final int maxBufferLength;

  const BarcodeScannerConfig({
    this.terminators = const [
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.numpadEnter,
      LogicalKeyboardKey.tab,
    ],
    this.bufferTimeout = const Duration(milliseconds: 100),
    this.deduplicationWindow = const Duration(milliseconds: 500),
    this.allowedFormats = const [],
    this.enableDebugLogs = true,
    this.maxBufferLength = 128,
  }) : assert(
         maxBufferLength >= 10 && maxBufferLength <= 256,
         'maxBufferLength must be between 10 and 256 characters. '
         'HID keyboard streaming is optimized for lightweight 1D retail barcodes; '
         'payloads exceeding 256 characters experience severe latency and timeout risks.',
       );
}
