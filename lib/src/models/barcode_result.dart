import 'barcode_format.dart';

/// Reasons a scanned or manually entered barcode may be rejected.
enum RejectionReason {
  /// The barcode string failed all known symbology regex patterns.
  unsupportedFormat,

  /// The barcode matched a known format, but that format was not in [BarcodeScannerConfig.allowedFormats].
  disallowedFormat,

  /// The scan was caught by the temporal deduplication shield.
  deduplicated,

  /// Zero characters were scanned or submitted.
  empty,

  /// The keystroke buffer exceeded [BarcodeScannerConfig.maxBufferLength].
  bufferOverflow,
}

/// A sealed result type representing the outcome of a barcode scan or
/// manual validation. Use exhaustive pattern matching to handle all cases.
sealed class BarcodeResult {
  /// The raw barcode string as read from the hardware scanner or manual input.
  final String rawValue;
  const BarcodeResult(this.rawValue);
}

/// A successfully captured barcode with its detected [format].
class BarcodeCapture extends BarcodeResult {
  final BarcodeFormat format;

  const BarcodeCapture(super.rawValue, this.format);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeCapture &&
          rawValue == other.rawValue &&
          format == other.format;

  @override
  int get hashCode => Object.hash(rawValue, format);

  @override
  String toString() => 'BarcodeCapture($rawValue, $format)';
}

/// A rejected barcode scan with the [reason] for rejection.
class BarcodeRejection extends BarcodeResult {
  final RejectionReason reason;
  final BarcodeFormat? format;

  const BarcodeRejection(super.rawValue, this.reason, [this.format]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeRejection &&
          runtimeType == other.runtimeType &&
          rawValue == other.rawValue &&
          reason == other.reason &&
          format == other.format;

  @override
  int get hashCode => Object.hash(rawValue, reason, format);

  @override
  String toString() => 'BarcodeRejection(rawValue: $rawValue, reason: ${reason.name}, format:${format?.name ?? "null"})';
}
